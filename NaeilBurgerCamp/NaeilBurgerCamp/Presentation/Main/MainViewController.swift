import UIKit
import SnapKit

final class MainViewController: UIViewController {
    private let horizontalLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "HorizontalLogo")

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
        view.addSubviews(horizontalLogo)
    }
    
    func setConstraints() {
        horizontalLogo.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.width.equalTo(170)
            make.height.equalTo(40)
        }
    }
    
    func setActions() {
        
    }
    
    func setBinding() {
        
    }
}
