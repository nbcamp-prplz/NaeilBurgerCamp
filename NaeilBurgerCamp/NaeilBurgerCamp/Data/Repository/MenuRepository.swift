import Foundation

protocol MenuRepositoryProtocol {
    func fetchCategories() async -> Result<Categories, FSError>
    func fetchMenuItems(for categoryID: String) async -> Result<MenuItems, FSError>
}

class MenuRepository: MenuRepositoryProtocol {
    private let service: FirestoreService

    init(service: FirestoreService) {
        self.service = service
    }

    func fetchCategories() async -> Result<Categories, FSError> {
        let result = await service.fetchCategories()
        switch result {
        case .success(let response):
            let fsCategories = response.documents.map{ $0.fields }
            return .success(fsCategories.map { Category(from: $0) })
        case .failure(let error):
            return .failure(error)
        }
    }

    func fetchMenuItems(for categoryID: String) async -> Result<MenuItems, FSError> {
        let result = await service.fetchMenuItems()
        switch result {
        case .success(let response):
            let menuItems = response.documents
                .filter { $0.fields.categoryID.stringValue == categoryID }
                .map { MenuItem(from: $0.fields) }
            return .success(menuItems)
        case .failure(let error):
            return .failure(error)
        }
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
