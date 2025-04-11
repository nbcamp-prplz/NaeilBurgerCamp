import UIKit

extension UICollectionReusableView {
    static var identifier: String {
        return String(describing: self)
    }

    static var isHeader: Bool {
        return identifier.hasSuffix("Header")
    }

    static var isFooter: Bool {
        return identifier.hasSuffix("Footer")
    }

    static var isCell: Bool {
        return identifier.hasSuffix("Cell")
    }
}
