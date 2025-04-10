import UIKit

extension UIImageView {
    func setImage(with menuID: String) {
        Task {
            guard let imageData = await ImageLoader.shared.loadImageData(for: menuID) else {
                return
            }
            await MainActor.run {
                self.image = UIImage(data: imageData)
            }
        }
    }
}
