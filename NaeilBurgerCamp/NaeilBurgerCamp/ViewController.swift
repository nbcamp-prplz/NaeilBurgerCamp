import UIKit
import SnapKit

final class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

private extension ViewController {
    func configure() {
        configureLayout()
        configureConstraints()
    }

    func configureLayout() {
        view.backgroundColor = .white
    }

    func configureConstraints() {

    }
}
