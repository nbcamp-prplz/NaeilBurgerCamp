import UIKit

extension UIImageView {
    func setImage(with urlString: String) {
        Task {
            guard let imageData = await ImageLoader.shared.loadImageData(for: urlString) else {
                return
            }
            await MainActor.run {
                self.image = UIImage(data: imageData)
            }
        }
    }
}
