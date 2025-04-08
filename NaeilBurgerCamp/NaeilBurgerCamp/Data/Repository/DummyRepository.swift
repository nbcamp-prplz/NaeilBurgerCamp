import Foundation

protocol DummyRepositoryProtocol {
    func fetchCategories() -> Categories
    func fetchMenuItems(for categoryID: String) -> MenuItems
}

class DummyRepository: DummyRepositoryProtocol {
    func fetchCategories() -> Categories {
        return Category.dummy()
    }

    func fetchMenuItems(for categoryID: String) -> MenuItems {
        return MenuItem.dummy()
    }
}

extension Category {
    static func dummy() -> [Category] {
        return [
            Category(
                from: FSCategory(
                    id: FSString(stringValue: "0"),
                    title: FSString(stringValue: "단품"),
                    sortOrder: FSInteger(integerValue: "0")
                )
            ),
            Category(
                from: FSCategory(
                    id: FSString(stringValue: "1"),
                    title: FSString(stringValue: "세트"),
                    sortOrder: FSInteger(integerValue: "1")
                )
            ),
            Category(
                from: FSCategory(
                    id: FSString(stringValue: "2"),
                    title: FSString(stringValue: "사이드"),
                    sortOrder: FSInteger(integerValue: "2")
                )
            ),

        ]
    }
}

extension MenuItem {
    static func dummy() -> [MenuItem] {
        return [
            MenuItem(
                from: FSMenuItem(
                    id: FSString(stringValue: "1"),
                    categoryID:  FSString(stringValue: "1"),
                    title:  FSString(stringValue: "1"),
                    price:  FSInteger(integerValue: "1"),
                    imageURL: FSString(stringValue: "1")
                )
            ),
            MenuItem(
                from: FSMenuItem(
                    id: FSString(stringValue: "2"),
                    categoryID:  FSString(stringValue: "2"),
                    title:  FSString(stringValue: "2"),
                    price:  FSInteger(integerValue: "2"),
                    imageURL: FSString(stringValue: "2")
                )
            ),
            MenuItem(
                from: FSMenuItem(
                    id: FSString(stringValue: "3"),
                    categoryID:  FSString(stringValue: "3"),
                    title:  FSString(stringValue: "3"),
                    price:  FSInteger(integerValue: "3"),
                    imageURL: FSString(stringValue: "3")
                )
            ),
        ]
    }
}
