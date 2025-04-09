import UIKit

enum CollectionViewSection {
    case category
    case menuItem
    case cartItem

    init?(_ sectionNumber: Int) {
        switch sectionNumber {
        case 0:
            self = .category
        case 1:
            self = .menuItem
        case 2:
            self = .cartItem
        default:
            return nil
        }
    }

    var sectionNumber: Int {
        switch self {
        case .category:
            return 0
        case .menuItem:
            return 1
        case .cartItem:
            return 2
        }
    }

    var layoutSection: NSCollectionLayoutSection {
        switch self {
        case .category:
            return Self.createCategorySection()
        case .menuItem:
            return Self.createMenuItemSection()
        case .cartItem:
            return Self.createCartItemSection()
        }
    }

    var numberOfItemsInSection: Int {
        switch self {
        case .category:
            return 5
        case .menuItem:
            return 8
        case .cartItem:
            return 3
        }
    }

    static func createCategorySection() -> NSCollectionLayoutSection {
        // 아이템 크기 설정 - estimated로 설정하여 콘텐츠에 따라 너비가 조정되도록 함
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // 그룹 크기 설정 - 아이템과 동일한 크기로 설정
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(80), heightDimension: .absolute(28)) // fractional로 0.5 변경
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // 섹션 설정
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous // 가로 스크롤 설정
        section.interGroupSpacing = 10 // 그룹 간 간격
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 24, bottom: 10, trailing: 24) // 섹션 여백

        return section
    }

    static func createMenuItemSection() -> NSCollectionLayoutSection {
        // 아이템 크기 설정
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)

        // 수평 그룹 설정 (한 행에 2개의 아이템)
        let horizontalGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.5)
        )
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: horizontalGroupSize,
            repeatingSubitem: item,
            count: 2
        )

        // 수직 그룹 설정 (2행으로 구성하여 총 4개의 아이템)
        let verticalGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(400)
        )
        let verticalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: verticalGroupSize,
            repeatingSubitem: horizontalGroup,
            count: 2
        )

        verticalGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)

        // 섹션 설정
        let section = NSCollectionLayoutSection(group: verticalGroup)
        section.orthogonalScrollingBehavior = .groupPaging

        // 푸터 설정
        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(60)

        )
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        section.boundarySupplementaryItems = [footer]

        return section
    }

    static func createCartItemSection() -> NSCollectionLayoutSection {
        // 아이템 크기 설정
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)

        // 그룹 크기 설정 (수직 스크롤이므로 한 행에 하나의 아이템)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(140)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )

        // 섹션 설정
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10 // 아이템 간 간격
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12) // 좌우 여백 설정

        // 헤더 설정
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(40)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]

        return section
    }
}
