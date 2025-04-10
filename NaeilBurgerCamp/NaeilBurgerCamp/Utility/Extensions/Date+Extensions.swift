import Foundation

extension Date {
    init?(from isoString: String) {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime] // "2025-04-08T22:54:31+09:00"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")

        guard let date = formatter.date(from: isoString) else { return nil }
        self = date
    }

    var isoString: String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime] // "2025-04-08T22:54:31+09:00"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")

        return formatter.string(from: self)
    }
}
