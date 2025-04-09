import UIKit

extension UICollectionView {
    func register(_ views: (AnyObject & BCReusableView).Type...) {
        views.forEach {
            if $0 is UICollectionViewCell.Type {
                self.register(
                    $0,
                    forCellWithReuseIdentifier: $0.identifier
                )
            } else if $0.reusableViewType == .header {
                self.register(
                    $0,
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: $0.identifier
                )
            } else {
                self.register(
                    $0,
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                    withReuseIdentifier: $0.identifier
                )
            }
        }
    }
}
