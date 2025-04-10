import UIKit

final class ImageCacheManger {
    static let shared = ImageCacheManger()

    private let cache = NSCache<NSString, UIImage>()

    private init() {}

    func loadImage(for urlString: String) async -> UIImage? {
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            print("캐시 이미지 사용")
            return cachedImage
        }

        guard let url = URL(string: urlString) else {
            return nil
        }

        do {
            let (data, _ ) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            self.cache.setObject(image, forKey: urlString as NSString)
            print("이미지 다운로드 성공")
            return image
        } catch {
            print("이미지 다운로드 실패")
            return nil
        }
    }
}
