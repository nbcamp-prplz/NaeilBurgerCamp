import UIKit
import SnapKit

final class MainViewController: UIViewController {
    private let dummyCategoryTitles = ["단품", "세트", "사이드", "음료"]
    private var dummySelectedCategoryIndex = 0
    private var currentPage = 0
    private let itemsPerPage = 4 // 한 페이지에 4개 아이템 (2x2 그리드)
    private var totalMenuItems = 8

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .horizontalLogo

        return imageView
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = createCompositionalLayout()

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .bcBackground1
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(
            CategoryCell.self,
            MenuItemCell.self,
            MenuItemSectionFooter.self,
            CartSectionHeader.self,
            CartItemCell.self,
        )
        collectionView.dataSource = self
        collectionView.delegate = self

        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            if let section = CollectionViewSection(sectionIndex) {
                return section.layoutSection
            }
            return nil
        }
    }
}

private extension MainViewController {
    func configure() {
        setLayout()
        setHierarchy()
        setConstraints()
    }
    
    func setLayout() {
        view.backgroundColor = .bcBackground1
    }
    
    func setHierarchy() {
        view.addSubviews(logoImageView, collectionView)
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
            make.directionalHorizontalEdges.equalToSuperview().inset(12)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20) // 하단 플로팅 버튼 공간 확보
        }
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        if let section = CollectionViewSection(section) {
            return section.numberOfItemsInSection
        }
        return 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell

            // 카테고리 데이터 설정 (예시)
            let categories = ["단품", "세트", "사이드", "음료"]
            let isSelected = indexPath.item == 0 // 첫 번째 아이템이 선택된 상태로 시작

            cell.configure(with: categories[indexPath.item])

            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuItemCell", for: indexPath) as! MenuItemCell
            let dummyImage: UIImage = .dummyBurger
            // 예시 데이터 설정
            let items = [
                ("통모짜와퍼", 10000, dummyImage),
                ("BBQ 통모짜와퍼", 10000, dummyImage),
                ("통모짜 와퍼주니어", 10000, dummyImage),
                ("통모짜 와퍼주니어", 10000, dummyImage),
                ("통모짜와퍼", 10000, dummyImage),
                ("BBQ 통모짜와퍼", 10000, dummyImage),
                ("통모짜 와퍼주니어", 10000, dummyImage),
                ("통모짜 와퍼주니어", 10000, dummyImage),
            ]

            let (title, price, image) = items[indexPath.item]
            cell.configure(image: image, title: title, price: price)

            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CartItemCell.identifier, for: indexPath) as! CartItemCell
            return cell
        default:
            return UICollectionViewCell()
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter && indexPath.section == 1 {
            let footerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: MenuItemSectionFooter.identifier,
                for: indexPath
            ) as! MenuItemSectionFooter

            footerView.delegate = self

            let maxPage = (totalMenuItems + itemsPerPage - 1) / itemsPerPage - 1
            footerView.updateButtonState(isPreviousEnabled: currentPage > 0,
                                         isNextEnabled: currentPage < maxPage)

            return footerView
        } else if kind == UICollectionView.elementKindSectionHeader && indexPath.section == 2 {
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: CartSectionHeader.identifier,
                for: indexPath
            ) as! CartSectionHeader

            return headerView
        }

        return UICollectionReusableView()
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        // 카테고리 선택 시 처리
        for i in 0..<collectionView.numberOfItems(inSection: 0) {
            let cell = collectionView.cellForItem(at: IndexPath(item: i, section: 0)) as? CategoryCell
//            cell?.updateSelection(i == indexPath.item)
        }

        // 추가 작업 (예: 다른 섹션 필터링 등)
    }

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
