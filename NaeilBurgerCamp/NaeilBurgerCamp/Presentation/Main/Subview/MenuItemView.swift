import UIKit

class MenuItemView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable, message: "storyboard is not supported")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MenuItemView {
    func configure() {
        setLayout()
        setHierarchy()
        setConstraints()
        setActions()
        setBinding()
    }

    func setLayout() {
        backgroundColor = .bcBackground1
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
