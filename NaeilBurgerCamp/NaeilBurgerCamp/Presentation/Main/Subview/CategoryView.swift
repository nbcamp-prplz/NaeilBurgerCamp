import UIKit

class CategoryView: UIView {
    private let categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .bcBackground1
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)

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
        categoryCollectionView.delegate = delegate
        categoryCollectionView.dataSource = dataSource
    }
}

private extension CategoryView {
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
        addSubviews(categoryCollectionView)
    }

    func setConstraints() {
        categoryCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func setActions() {

    }

    func setBinding() {

    }
}

// delegate의 경우 category - menuCategoryContainerView - mainViewController 구조라 주입을 두 단계에 거쳐서 해줘야하는데 이런 경우 어떤 방식을 쓰는지.

// reactive extension을 통해 depth 줄이기
