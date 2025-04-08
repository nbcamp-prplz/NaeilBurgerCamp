import Foundation
import RxSwift

protocol MenuUseCaseProtocol {
    var categories: BehaviorSubject<Categories> { get }
    var menuItems: BehaviorSubject<MenuItems> { get }

    func fetchCategories()
    func fetchMenuItems(for categoryID: String)
}

final class MenuUseCase: MenuUseCaseProtocol {
    private let repository: DummyRepositoryProtocol
    let categories = BehaviorSubject<Categories>(value: [])
    let menuItems = BehaviorSubject<MenuItems>(value: [])

    init(repository: DummyRepositoryProtocol) {
        self.repository = repository
    }

    func fetchCategories() {
        categories.onNext(repository.fetchCategories())
    }
    
    func fetchMenuItems(for categoryID: String) {
        menuItems.onNext(repository.fetchMenuItems(for: categoryID))
    }
}
