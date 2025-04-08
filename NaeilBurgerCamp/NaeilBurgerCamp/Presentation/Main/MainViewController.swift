import UIKit
import SnapKit

final class MainViewController: UIViewController {
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .horizontalLogo

        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

private extension MainViewController {
    func configure() {
        setLayout()
        setHierarchy()
        setConstraints()
        setActions()
        setBinding()
    }
    
    func setLayout() {
        view.backgroundColor = .bcBackground1
    }
    
    func setHierarchy() {
        view.addSubviews(logoImageView)
    }
    
    func setConstraints() {
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.equalTo(170)
            make.height.equalTo(40)
        }
    }
    
    func setActions() {
        
    }
    
    func setBinding() {
        
    }
}
