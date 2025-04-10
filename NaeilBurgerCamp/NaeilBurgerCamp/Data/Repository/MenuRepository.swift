import Foundation

protocol MenuRepositoryProtocol {
    func fetchCategories() async -> Result<Categories, FSError>
    func fetchMenuItems(for categoryID: String) async -> Result<MenuItems, FSError>
}

final class MenuRepository: MenuRepositoryProtocol {
    private let service: FirestoreService

    init(service: FirestoreService = FirestoreService()) {
        self.service = service
    }

    func fetchCategories() async -> Result<Categories, FSError> {
        let result = await service.fetchCategories()
        switch result {
        case .success(let response):
            let fsCategories = response.documents.map{ $0.fields }
            return .success(fsCategories.map { Category(from: $0) }.sorted(by: { $0.sortOrder < $1.sortOrder }))
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
