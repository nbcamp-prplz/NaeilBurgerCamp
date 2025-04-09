import UIKit

class MenuItemView: UIView {
    private let menuCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .bcBackground1
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MenuItemCell.self, forCellWithReuseIdentifier: MenuItemCell.identifier)

        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable, message: "storyboard is not supported")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setCollectionView(_ dataSource: UICollectionViewDataSource, _ delegate: UICollectionViewDelegate) {
        menuCollectionView.delegate = delegate
        menuCollectionView.dataSource = dataSource
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
