import Foundation
import RxSwift
import RxCocoa

protocol MainViewModelProtocol: AnyObject {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

struct DummyOrderDetails {
    let menuItem: MenuItem
    let quantity: Int
}

final class MainViewModel: MainViewModelProtocol {
    private let menuUseCase: MenuUseCaseProtocol = MenuUseCase()

    private var cart = BehaviorRelay<Cart>(value: Cart())
    private let disposeBag = DisposeBag()

    struct Input {
        let viewDidLoad: Observable<Void>
        let selectCategory: Observable<String>
        let addMenuItem: Observable<MenuItem>
        let removeMenuItem: Observable<MenuItem>
        let resetCart: Observable<Void>
        let placeOrder: Observable<Void>
    }
    struct Output {
        let categories = BehaviorRelay<Categories>(value: [])
        let selectedCategoryIndex = BehaviorRelay<Int>(value: 0)
        let menuItems = BehaviorRelay<MenuItems>(value: [])
        let cart: Observable<Cart>
        let cancelButtonIsEnabled = BehaviorRelay<Bool>(value: false)
        let orderButtonIsEnabled = BehaviorRelay<Bool>(value: false)
    }
    
    func transform(input: Input) -> Output {
        var output = Output(cart: cart.asObservable())

        input.viewDidLoad
            .bind(onNext: { [weak self] in
                guard let self else { return }
                Task {
                    await self.menuUseCase.fetchCategories()
                }
            })
            .disposed(by: disposeBag)

        input.selectCategory
            .bind(onNext: { [weak self] categoryID in
                guard let self else { return }
                Task {
                    await self.menuUseCase.fetchMenuItems(for: categoryID)
                }
            })
            .disposed(by: disposeBag)

        input.addMenuItem
            .bind(onNext: { [weak self] menuItem in
                guard let self else { return }
                var updatedCart = self.cart.value
                updatedCart.addMenuItem(with: menuItem)
                self.cart.accept(updatedCart)
            })
            .disposed(by: disposeBag)

        input.removeMenuItem
            .bind(onNext: { [weak self] menuItem in
                guard let self else { return }
                var updatedCart = self.cart.value
                updatedCart.removeMenuItem(with: menuItem)
                self.cart.accept(updatedCart)
            })
            .disposed(by: disposeBag)
        
        input.resetCart
            .bind(onNext: { [weak self] in
                guard let self else { return }
                self.cart.accept(Cart())
            })
            .disposed(by: disposeBag)

        input.placeOrder
            .bind { [weak self] in
                guard let self else { return }
                Task {
                    // TODO: OrderUseCase.placeOrder(with: self.cart.value)
                    self.cart.accept(Cart())
                }
            }
            .disposed(by: disposeBag)

        return output
    }
}
