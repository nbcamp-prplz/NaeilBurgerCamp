import UIKit

final class ImageLoader {
    static let shared = ImageLoader()

    private let cache = NSCache<NSString, UIImage>()
    private let taskStore = OngoingTaskStore()

    private init() {}

    func loadImage(for urlString: String) async -> UIImage? {
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            print("캐시 이미지 사용")
            return cachedImage
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

                cache.setObject(image, forKey: urlString as NSString)
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
    }
}
