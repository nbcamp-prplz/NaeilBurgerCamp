import Foundation

struct Category: Hashable {
    let id: String
    let title: String
    let sortOrder: Int

    init(from dto: FSCategory) {
        self.id = dto.id.stringValue
        self.title = dto.title.stringValue
        self.sortOrder = Int(dto.sortOrder.integerValue) ?? Int.max
    }
}

typealias Categories = [Category]
