import UIKit
import SnapKit

final class MainViewController: UIViewController {
    
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
        view.backgroundColor = UIColor(named: "BCBackground1")
    }
    
    func setHierarchy() {
        
    }
    
    func setConstraints() {
        
    }
    
    func setActions() {
        
    }
    
    func setBinding() {
        
    }
}
