import Foundation

struct MenuItem: Hashable {
    let id: String
    let categoryID: String
    let title: String
    let price: Int

    init(from dto: FSMenuItem) {
        self.id = dto.id.stringValue
        self.categoryID = dto.categoryID.stringValue
        self.title = dto.title.stringValue
        self.price = Int(dto.price.integerValue) ?? 0
    }
}

typealias MenuItems = [MenuItem]
