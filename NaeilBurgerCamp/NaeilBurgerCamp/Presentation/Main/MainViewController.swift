import UIKit
import SnapKit
import RxSwift
import RxCocoa

typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
typealias SnapShot = NSDiffableDataSourceSnapshot<Section, Item>

final class MainViewController: UIViewController {
    private var currentPage = 0
    private let itemsPerPage = 4 // 한 페이지에 4개 아이템 (2x2 그리드)
    private var totalMenuItems = 8

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
                    if indexPath.section == 0 && indexPath.item == 0 {
                        collectionView.selectItem(
                            at: IndexPath(item: 0, section: 0),
                            animated: false,
                            scrollPosition: .centeredHorizontally
                        )
                    }
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

                if self.selectCategory.value.isEmpty {
                    selectCategory.accept(categories.first?.id ?? "")
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

                dataSource?.apply(snapshot, animatingDifferences: true)
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

extension MainViewController: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateCurrentPageFromScrollPosition()
    }

    // 버튼을 통한 페이징 애니메이션이 끝났을 때 호출
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        updateCurrentPageFromScrollPosition()
    }

    private func updateCurrentPageFromScrollPosition() {
        // 메뉴 아이템 섹션에 대해서만 처리
        guard let layoutAttributes = collectionView.collectionViewLayout.layoutAttributesForElements(in: collectionView.bounds)?.filter({ $0.representedElementCategory == .cell && $0.indexPath.section == 1 }) else {
            return
        }

        // 화면에 보이는 첫 번째 아이템의 인덱스로 페이지 계산
        if let firstVisibleItem = layoutAttributes.sorted(by: { $0.indexPath.item < $1.indexPath.item }).first {
            let newPage = firstVisibleItem.indexPath.item / itemsPerPage

            // 페이지가 변경된 경우에만 업데이트
            if newPage != currentPage {
                currentPage = newPage

                // 푸터 버튼 상태 업데이트
                if let footerView = collectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionFooter).first as? MenuItemSectionFooter {
                    updateFooterButtonState(footerView: footerView)
                }
            }
        }
    }
}

extension MainViewController: MenuItemFooterViewDelegate {
    func didTapPreviousButton() {
        if currentPage > 0 {
            currentPage -= 1
            scrollToPage(page: currentPage)
        }
    }

    func didTapNextButton() {
        let maxPage = (totalMenuItems + itemsPerPage - 1) / itemsPerPage - 1 // 총 페이지 수 계산 (올림 나눗셈)
        if currentPage < maxPage {
            currentPage += 1
            scrollToPage(page: currentPage)
        }
    }

    private func scrollToPage(page: Int) {
        let indexPath = IndexPath(item: page * itemsPerPage, section: 1)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)

        // 푸터뷰 버튼 상태 업데이트를 위해 푸터뷰 참조 가져오기
        if let footerView = collectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionFooter).first as? MenuItemSectionFooter {
            updateFooterButtonState(footerView: footerView)
        }
    }

    // 푸터뷰의 버튼 상태 업데이트 (첫 페이지나 마지막 페이지에서는 버튼 비활성화)
    private func updateFooterButtonState(footerView: MenuItemSectionFooter) {
        let maxPage = (totalMenuItems + itemsPerPage - 1) / itemsPerPage - 1

        // 페이지에 따른 버튼 활성화/비활성화
        footerView.updateButtonState(isPreviousEnabled: currentPage > 0,
                                    isNextEnabled: currentPage < maxPage)
    }
}
