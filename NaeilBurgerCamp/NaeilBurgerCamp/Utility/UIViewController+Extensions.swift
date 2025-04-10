import UIKit

extension UIViewController {
    func showResetCartAlert(completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(
            title: String(.orderCancel),
            message: String(.wantCancel),
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: String(.no),
                                      style: .cancel))
        alert
            .addAction(
                UIAlertAction(
                    title: String(.yes),
                    style: .destructive,
                    handler: { _ in
            completionHandler()
        })
)

        self.present(alert, animated: true)
    }
}
