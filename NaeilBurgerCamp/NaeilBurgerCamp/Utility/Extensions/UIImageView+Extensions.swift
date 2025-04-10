import UIKit

extension UIImageView {
    func setImage(with urlString: String) {
        Task {
            let image = await ImageCacheManger.shared.loadImage(for: urlString)
            await MainActor.run {
                self.image = image
            }
        }
    }
}
