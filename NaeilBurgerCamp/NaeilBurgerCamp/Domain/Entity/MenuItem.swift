import Foundation

struct MenuItem {
    let id: String
    let categoryID: String
    let title: String
    let price: Int
    let imageURL: String

    init(from dto: FSMenuItem) {
        self.id = dto.id.stringValue
        self.categoryID = dto.categoryID.stringValue
        self.title = dto.title.stringValue
        self.price = Int(dto.price.integerValue) ?? 0
        self.imageURL = dto.imageURL.stringValue
    }
}

typealias MenuItems = [MenuItem]
