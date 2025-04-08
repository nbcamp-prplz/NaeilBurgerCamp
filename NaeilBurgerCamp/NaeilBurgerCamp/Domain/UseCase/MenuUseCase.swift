import Foundation
import RxSwift

protocol MenuUseCaseProtocol {
    func fetchCategories()
    func fetchMenuItems(categoryID: String)
    var categories: BehaviorSubject<Categories> { get }
    var menuItems: BehaviorSubject<MenuItems> { get }
}

class MenuUseCase: MenuUseCaseProtocol {
    private let repository: DummyRepositoryProtocol
    let categories = BehaviorSubject<Categories>(value: [])
    let menuItems = BehaviorSubject<MenuItems>(value: [])

    init(repository: DummyRepositoryProtocol) {
        self.repository = repository
    }

    func fetchCategories() {
        categories.onNext(repository.fetchCategories())
    }
    
    func fetchMenuItems(categoryID: String)  {
        menuItems.onNext(repository.fetchMenuItems(categoryID: categoryID))
    }
}
