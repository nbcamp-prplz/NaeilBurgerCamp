import UIKit
import SnapKit
import RxSwift
import RxCocoa

typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
typealias SnapShot = NSDiffableDataSourceSnapshot<Section, Item>

final class MainViewController: UIViewController {
    private let viewModel = MainViewModel()
    private var dataSource: DataSource?

    private let selectCategory = BehaviorRelay<String>(value: "")
    private let addMenuItem = PublishRelay<MenuItem>()
    private let increaseMenuItem = PublishRelay<Int>()
    private let decreaseMenuItem = PublishRelay<Int>()
    private let resetCart = PublishRelay<Void>()
    private let placeOrder = PublishRelay<Void>()
    private let disposeBag = DisposeBag()

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .lightHorizontalLogo

        return imageView
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView.withCompositionalLayout()
        collectionView.backgroundColor = .bcBackground1
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(
            CategoryCell.self,
            MenuItemCell.self,
            MenuItemSectionFooter.self,
            CartSectionHeader.self,
            CartItemCell.self
        )

        return collectionView
    }()

    private let placeOrderView = PlaceOrderView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            let isLightMode = traitCollection.userInterfaceStyle == .light
            logoImageView.image = isLightMode ? .lightHorizontalLogo : .darkHorizontalLogo
        }
    }
}

private extension MainViewController {
    func configure() {
        setLayout()
        setHierarchy()
        setDataSource()
        setConstraints()
        setBinding()
    }
    
    func setLayout() {
        view.backgroundColor = .bcBackground1
        let isLightMode = UIScreen.main.traitCollection.userInterfaceStyle == .light
        logoImageView.image = isLightMode ? .lightHorizontalLogo : .darkHorizontalLogo
    }
    
    func setHierarchy() {
        view.addSubviews(logoImageView, collectionView, placeOrderView)
    }

    func setDataSource() {
        dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                switch itemIdentifier {
                case .category(let category):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: CategoryCell.identifier,
                        for: indexPath
                    ) as? CategoryCell else { return UICollectionViewCell() }
                    cell.configure(with: category.title)
                    return cell
                case .menuItem(let menuItem):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: MenuItemCell.identifier,
                        for: indexPath
                    ) as? MenuItemCell else { return UICollectionViewCell() }
                    cell.configure(with: menuItem)
                    return cell
                case .cart(let detail):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: CartItemCell.identifier,
                        for: indexPath
                    ) as? CartItemCell else { return UICollectionViewCell() }
                    cell.configure(with: detail)
                    cell.plusButtonTapped
                        .bind { [weak self] in
                            guard let self,
                                  let newIndexPath = dataSource?.indexPath(for: itemIdentifier) else { return }
                            self.increaseMenuItem.accept(newIndexPath.item)
                        }
                        .disposed(by: cell.disposeBag)
                    cell.minusButtonTapped
                        .bind { [weak self] in
                            guard let self,
                                  let newIndexPath = dataSource?.indexPath(for: itemIdentifier) else { return }
                            self.decreaseMenuItem.accept(newIndexPath.item)
                        }
                        .disposed(by: cell.disposeBag)
                    return cell
                }
            })

        dataSource?.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) in
            guard let self,
                  let section = self.dataSource?.sectionIdentifier(for: indexPath.section) else {
                return UICollectionReusableView()
            }

            switch section {
            case .menuItems:
                return collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: MenuItemSectionFooter.identifier,
                    for: indexPath
                )
            case .cartItems:
                return collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: CartSectionHeader.identifier,
                    for: indexPath
                )
            default:
                return UICollectionReusableView()
            }
        }
    }

    func setConstraints() {
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.equalTo(170)
            make.height.equalTo(40)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(16)
            make.directionalHorizontalEdges.equalToSuperview()
            make.bottom.equalTo(placeOrderView.snp.top)
        }

        placeOrderView.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }

    func setBinding() {
        let input = MainViewModel.Input(
            selectCategory: selectCategory.asObservable(),
            addMenuItem: addMenuItem.asObservable(),
            increaseMenuItem: increaseMenuItem.asObservable(),
            decreaseMenuItem: decreaseMenuItem.asObservable(),
            resetCart: resetCart.asObservable(),
            placeOrder: placeOrder.asObservable()
        )
        let output = viewModel.transform(input: input)

        Observable.combineLatest(output.categories, output.menuItems, output.cart)
            .observe(on: MainScheduler.instance)
            .do { [weak self] _, _, cart in
                guard let self else { return }
                self.placeOrderView.updateOrderButtonTitle(with: cart)
            }
            .bind { [weak self] categories, menuItems, cart in
                guard let self else { return }
                guard !self.selectCategory.value.isEmpty else {
                    selectCategory.accept(categories.first?.id ?? "")
                    return
                }

                var snapshot = SnapShot()

                let categoriesSection = Section.categories
                let category = categories.map { Item.category($0) }

                let menuItemsSection = Section.menuItems
                let menuItem = menuItems.map { Item.menuItem($0) }

                let cartSection = Section.cartItems
                let cartItem = cart.details.map { Item.cart($0) }

                snapshot.deleteAllItems()
                snapshot.appendSections([categoriesSection, menuItemsSection, cartSection])
                snapshot.appendItems(category, toSection: categoriesSection)
                snapshot.appendItems(menuItem, toSection: menuItemsSection)
                snapshot.appendItems(cartItem, toSection: cartSection)

                dataSource?.apply(snapshot, animatingDifferences: true) { [weak self] in
                    guard let self else { return }
                    if self.selectCategory.value == categories.first?.id {
                        let indexPath = IndexPath(item: 0, section: 0)
                        self.collectionView.selectItem(
                            at: indexPath,
                            animated: false,
                            scrollPosition: .centeredHorizontally
                        )
                    }
                }
            }
            .disposed(by: disposeBag)

        output.cancelButtonIsHidden
            .observe(on: MainScheduler.instance)
            .bind { [weak self] isHidden in
                guard let self else { return }
                self.placeOrderView.updateCancelButtonIsHidden(isHidden)
            }
            .disposed(by: disposeBag)

        output.orderButtonIsEnabled
            .observe(on: MainScheduler.instance)
            .bind { [weak self] isEnabled in
                guard let self else { return }
                self.placeOrderView.updateOrderButtonIsEnabled(isEnabled)
            }
            .disposed(by: disposeBag)

        output.orderSuccess
            .bind { [weak self] in
                guard let self else { return }
                self.placeOrderView.showOrderSuccessMessage()
            }
            .disposed(by: disposeBag)

        output.errorMessage
            .bind { message in
                print(message)
            }
            .disposed(by: disposeBag)

        collectionView.rx.itemSelected
            .bind { [weak self] indexPath in
                guard let self else { return }
                switch indexPath.section {
                case 0: // Category
                    let category = output.categories.value[indexPath.item]
                    self.selectCategory.accept(category.id)
                case 1: // MenuItems
                    let menuItem = output.menuItems.value[indexPath.item]
                    self.addMenuItem.accept(menuItem)
                default:
                    ()
                }
            }
            .disposed(by: disposeBag)



        placeOrderView.cancelButtonTapped
            .bind { [weak self] in
                guard let self else { return }
                self.showResetCartAlert {
                    self.resetCart.accept(())
                }
            }
            .disposed(by: disposeBag)

        placeOrderView.orderButtonTapped
            .bind { [weak self] in
                guard let self else { return }
                self.placeOrder.accept(())
            }
            .disposed(by: disposeBag)
    }
}
