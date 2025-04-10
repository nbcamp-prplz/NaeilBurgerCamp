import Foundation

final actor ExpiryDateStore {
    private var expiryDates: [String: Date] = [:]

    func getExpiryDate(for key: String) -> Date? {
        return expiryDates[key]
    }

    func setExpiryDate(for key: String, to date: Date) {
        expiryDates[key] = date
    }

    func clear() {
        expiryDates.removeAll()
    }
}
