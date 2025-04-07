import Foundation

struct FSMenuItems: Decodable {
    let documents: [FSMenuItemDocument]
}

struct FSMenuItemDocument: Decodable {
    let name: String
    let fields: FSMenuItem
}

struct FSMenuItem: Decodable {
    let title: FSString
    let category: FSString
    let price: FSInteger
}

struct FSString: Decodable {
    let stringValue: String
}

struct FSInteger: Decodable {
    let integerValue: String
}
