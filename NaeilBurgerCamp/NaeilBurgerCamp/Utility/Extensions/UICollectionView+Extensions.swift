import UIKit

extension UICollectionView {
    static func withCompositionalLayout() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            if let section = Section(sectionIndex) {
                return section.layoutSection
            }
            return nil
        }
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }

    func register(_ metatypes: UICollectionReusableView.Type...) {
        metatypes.forEach { metatype in
            if metatype.isHeader {
                self.register(
                    metatype,
                    forSupplementaryViewOfKind: Self.elementKindSectionHeader,
                    withReuseIdentifier: metatype.identifier
                )
            } else if metatype.isFooter {
                self.register(
                    metatype,
                    forSupplementaryViewOfKind: Self.elementKindSectionFooter,
                    withReuseIdentifier: metatype.identifier
                )
            } else if metatype.isCell {
                self.register(
                    metatype,
                    forCellWithReuseIdentifier: metatype.identifier
                )
            }
        }
    }
}
