import Foundation
import os

final class ImageLoader {
    static let shared = ImageLoader()

    private let cache = NSCache<NSString, NSData>()
    private let taskStore = OngoingTaskStore<Data>()
    private let expiryStore = ExpiryDateStore()
    private let ttl: TimeInterval = 5 * 60 // 5분

    private let baseUrl = "https://raw.githubusercontent.com/nbcamp-prplz/NaeilBurgerCamp/refs/heads/dev/Resources"

    private init() {
        cache.totalCostLimit = 50 * 1024 * 1024 // 캐시 총 용량 제한 (50MB)
    }

    func loadImageData(for menuItemID: String) async -> Data? {
        let urlString = "\(baseUrl)/\(menuItemID).png"

        if let cachedImageData = cache.object(forKey: urlString as NSString),
           let expiryDate = await expiryStore.expiryDate(for: urlString) {

            if expiryDate > Date() {
                os_log("[ImageLoader]: 캐시 이미지 사용", type: .default)
                return cachedImageData as Data
            }

            cache.removeObject(forKey: urlString as NSString)
        }

        if let ongoingTask = await taskStore.task(for: urlString) {
            let image = await ongoingTask.value
            os_log("[ImageLoader]: 중복 요청 방지 후 이미지 데이터 반환", type: .default)
            return image
        }

        let task = Task<Data?, Never> {
            defer {
                Task { await taskStore.removeTask(for: urlString) }
            }

            guard let url = URL(string: urlString) else { return nil }

            do {
                let (data, _) = try await URLSession.shared.data(from: url) //TODO: URLSession Error 처리
                cache.setObject(
                    data as NSData,
                    forKey: urlString as NSString,
                    cost: data.count
                )
                await expiryStore.setExpiryDate(
                    for: urlString,
                    to: Date().addingTimeInterval(ttl)
                )
                os_log("[ImageLoader]: 이미지 다운로드 성공", type: .default)
                return data
            } catch {
                os_log("[ImageLoader]: 이미지 다운로드 실패", type: .fault)
                return nil
            }
        }

        await taskStore.setTask(task, for: urlString)
        return await task.value
    }

    func clearCache() async {
        os_log("[ImageLoader]: 이미지 캐시 초기화", type: .default)
        cache.removeAllObjects()
        await taskStore.clear()
        await expiryStore.clear()
    }
}
