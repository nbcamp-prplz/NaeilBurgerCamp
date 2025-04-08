import Foundation

protocol DummyRepositoryProtocol {
    func fetchCategories() -> Categories
    func fetchMenuItems(categoryID: String) -> MenuItems
}

class DummyRepository: DummyRepositoryProtocol {
    func fetchCategories() -> Categories {
        return Category.dummy()
    }

    func fetchMenuItems(categoryID: String) -> MenuItems {
        return MenuItem.dummy()
    }
}

extension Category {
    static func dummy() -> [Category] {
        return [
            Category(id: "1", title: "단품", priority: 0),
            Category(id: "2", title: "세트", priority: 0),
            Category(id: "3", title: "사이드", priority: 0),
            Category(id: "4", title: "음료", priority: 0),
        ]
    }
}

extension MenuItem {
    static func dummy() -> [MenuItem] {
        return [
            MenuItem(id: 0, categoryID: "1", title: "a", price: 123, imageURL: "Asd"),
            MenuItem(id: 1, categoryID: "2", title: "a", price: 123, imageURL: "Asd"),
            MenuItem(id: 2, categoryID: "3", title: "a", price: 123, imageURL: "Asd"),
            MenuItem(id: 3, categoryID: "4", title: "a", price: 123, imageURL: "Asd"),
        ]
    }
}
