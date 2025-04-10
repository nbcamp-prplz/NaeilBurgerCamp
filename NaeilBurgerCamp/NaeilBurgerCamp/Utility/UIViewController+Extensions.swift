import UIKit

extension UIViewController {
    func showResetCartAlert(completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(
            title: "주문 취소".localized,
            message: "정말로 주문을 취소하시겠어요?".localized,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "아니요".localized, style: .cancel))
        alert
            .addAction(UIAlertAction(title: "네".localized, style: .destructive, handler: { _ in
            completionHandler()
        }))

        self.present(alert, animated: true)
    }
}
