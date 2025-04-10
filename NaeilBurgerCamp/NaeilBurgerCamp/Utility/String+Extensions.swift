import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, value: self, comment: "")
    }

    func localized(with argument: CVarArg...) -> String {
        return String(format: localized, argument)
    }
}
