import Foundation

struct FSMenuItems: Decodable {
    let documents: [FSMenuItemDocument]
}

struct FSMenuItemDocument: Decodable {
    let name: String
    let fields: FSMenuItem
}

struct FSMenuItem: Decodable {
    let id: FSString
    let categoryID: FSString
    let title: FSString
    let price: FSInteger
    let imageURL: FSString
}
