import Foundation
import RxSwift

protocol MenuUseCaseProtocol {
    var categories: PublishSubject<Categories> { get }
    var menuItems: PublishSubject<MenuItems> { get }
    var errorMessage: PublishSubject<String> { get }

    func fetchCategories() async
    func fetchMenuItems(for categoryID: String) async
}

final class MenuUseCase: MenuUseCaseProtocol {
    private let repository: MenuRepositoryProtocol
    let categories = PublishSubject<Categories>()
    let menuItems = PublishSubject<MenuItems>()
    let errorMessage = PublishSubject<String>()

    init(repository: MenuRepositoryProtocol = MenuRepository()) {
        self.repository = repository
    }

    func fetchCategories() async {
        let result = await repository.fetchCategories()
        switch result {
        case .success(let categories):
            self.categories.onNext(categories)
        case .failure(let error):
            self.errorMessage.onNext(error.errorDescription ?? error.localizedDescription)
        }
    }
    
    func fetchMenuItems(for categoryID: String) async {
        let result = await repository.fetchMenuItems(for: categoryID)
        switch result {
        case .success(let menuItems):
            self.menuItems.onNext(menuItems)
        case .failure(let error):
            self.errorMessage.onNext(error.errorDescription ?? error.localizedDescription)
        }
    }
}
