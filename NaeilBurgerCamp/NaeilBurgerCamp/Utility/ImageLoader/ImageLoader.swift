import UIKit

final class ImageLoader {
    static let shared = ImageLoader()

    private let cache = NSCache<NSString, UIImage>()
    private let taskStore = OngoingTaskStore()
    private let expiryStore = ExpiryDateStore()
    private let ttl: TimeInterval = 5 * 60 // 5분

    private init() {
        cache.totalCostLimit = 50 * 1024 * 1024 // 캐시 총 용량 제한 (50MB)
    }

    func loadImage(for urlString: String) async -> UIImage? {
        if let cachedImage = cache.object(forKey: urlString as NSString),
           let expiryDate = await expiryStore.getExpiryDate(for: urlString) {

            if expiryDate > Date() {
                print("캐시 이미지 사용")
                return cachedImage
            }

            cache.removeObject(forKey: urlString as NSString)
        }

        if let ongoingTask = await taskStore.getTask(for: urlString) {
            let image = await ongoingTask.value
            print("중복 요청 방지 후 이미지 반환")
            return image
        }

        let task = Task<UIImage?, Never> {
            defer {
                Task { await taskStore.removeTask(for: urlString) }
            }

            guard let url = URL(string: urlString) else { return nil }

            do {
                let (data, _ ) = try await URLSession.shared.data(from: url)
                guard let image = UIImage(data: data) else { return nil }

                cache.setObject(image, forKey: urlString as NSString, cost: data.count)
                await expiryStore.setExpiryDate(for: urlString, to: Date().addingTimeInterval(ttl))
                print("이미지 다운로드 성공")
                return image
            } catch {
                print("이미지 다운로드 실패")
                return nil
            }
        }

        await taskStore.setTask(task, for: urlString)
        return await task.value
    }

    func clearCache() async {
        cache.removeAllObjects()
        await taskStore.clear()
        await expiryStore.clear()
    }
}
