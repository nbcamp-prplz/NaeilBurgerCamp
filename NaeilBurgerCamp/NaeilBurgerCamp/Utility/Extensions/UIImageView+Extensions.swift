import UIKit

extension UIImageView {
    func setImage(with menuItemID: String) {
        Task {
            guard let imageData = await ImageLoader.shared.loadImageData(for: menuItemID) else {
                return
            }
            await MainActor.run {
                self.image = UIImage(data: imageData)
            }
        }
    }
}
