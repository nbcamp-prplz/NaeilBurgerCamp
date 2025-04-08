import UIKit

class MenuCategoryContainerView: UIView {
    let categoryView = CategoryView()
    private let menuItemView = MenuItemView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable, message: "storyboard is not supported")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MenuCategoryContainerView {
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
        addSubviews(categoryView)
    }

    func setConstraints() {
        categoryView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func setActions() {

    }

    func setBinding() {

    }
}
