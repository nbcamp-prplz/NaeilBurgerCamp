import Foundation

extension String {
    enum LocalizedType: String {
        case orderDetails
        case shopInfo
        case cancel
        case orderSuccess
        case pleaseAddItem
        case ordering
        case orderCancel
        case resetAlertTitle
        case no
        case yes
        
    }
    
    init(_ localizedType: LocalizedType) {
        self = localizedType.rawValue.localized
    }
    
    init(_ localizedType: LocalizedType, with argument: CVarArg...) {
        let string = localizedType.rawValue.localized
        self = .init(format: string, argument)
    }
    
    var localized: String {
        return NSLocalizedString(self, value: self, comment: "")
    }

    func localized(with argument: CVarArg...) -> String {
        return String(format: localized, argument)
    }
}
