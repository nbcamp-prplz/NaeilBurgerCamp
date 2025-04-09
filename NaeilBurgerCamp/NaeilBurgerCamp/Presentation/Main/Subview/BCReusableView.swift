import UIKit

enum ReusableViewType {
    case cell
    case header
    case footer
}

protocol BCReusableView {
    static var identifier: String { get }
    static var reusableViewType: ReusableViewType { get }
}
