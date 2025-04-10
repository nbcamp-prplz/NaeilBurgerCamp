import Foundation

struct FSMenuItems: Codable {
    let documents: [FSMenuItemDocument]
}

struct FSMenuItemDocument: Codable {
    let name: String
    let fields: FSMenuItem
}

struct FSMenuItem: Codable {
    let id: FSString
    let categoryID: FSString
    let title: FSString
    let price: FSInteger
}
