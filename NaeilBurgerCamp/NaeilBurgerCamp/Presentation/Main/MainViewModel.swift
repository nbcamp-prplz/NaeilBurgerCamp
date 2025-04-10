import Foundation
import RxSwift
import RxCocoa

protocol MainViewModelProtocol: AnyObject {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

final class MainViewModel: MainViewModelProtocol {
    private let menuUseCase: MenuUseCaseProtocol = MenuUseCase()
    private let orderUseCase: OrderUseCaseProtocol = OrderUseCase()

    private var cart = BehaviorRelay<Cart>(value: Cart())
    private let disposeBag = DisposeBag()

    struct Input {
        let selectCategory: Observable<String>
        let addMenuItem: Observable<MenuItem>
        let increaseMenuItem: Observable<Int>
        let decreaseMenuItem: Observable<Int>
        let resetCart: Observable<Void>
        let placeOrder: Observable<Void>
    }

    struct Output {
        let categories = BehaviorRelay<Categories>(value: [])
        let menuItems = BehaviorRelay<MenuItems>(value: [])
        let cart: Observable<Cart>
        let cancelButtonIsHidden = BehaviorRelay<Bool>(value: true)
        let orderButtonIsEnabled = BehaviorRelay<Bool>(value: false)
        let orderSuccess = PublishRelay<Void>()
        let errorMessage = BehaviorRelay<String>(value: "")
    }
    
    func transform(input: Input) -> Output {
        let output = Output(cart: cart.asObservable())

        Task {
            await menuUseCase.fetchCategories()
        }

        input.selectCategory
            .bind { [weak self] categoryID in
                guard let self else { return }
                Task {
                    await self.menuUseCase.fetchMenuItems(for: categoryID)
                }
            }
            .disposed(by: disposeBag)

        input.addMenuItem
            .bind { [weak self] menuItem in
                guard let self else { return }
                var updatedCart = self.cart.value
                updatedCart.addMenuItem(with: menuItem)
                self.cart.accept(updatedCart)
            }
            .disposed(by: disposeBag)

        input.increaseMenuItem
            .bind { [weak self] index in
                guard let self else { return }
                var updatedCart = self.cart.value
                updatedCart.increaseMenuItem(at: index)
                self.cart.accept(updatedCart)
            }
            .disposed(by: disposeBag)

        input.decreaseMenuItem
            .bind { [weak self] index in
                guard let self else { return }
                var updatedCart = self.cart.value
                updatedCart.decreaseMenuItem(at: index)
                self.cart.accept(updatedCart)
            }
            .disposed(by: disposeBag)
        
        input.resetCart
            .bind { [weak self] in
                guard let self else { return }
                self.cart.accept(Cart())
            }
            .disposed(by: disposeBag)

        input.placeOrder
            .bind { [weak self] in
                guard let self else { return }
                Task {
                    await self.orderUseCase.placeOrder(for: self.cart.value)
                    self.cart.accept(Cart())
                }
            }
            .disposed(by: disposeBag)

        menuUseCase.categories
            .bind(to: output.categories)
            .disposed(by: disposeBag)

        menuUseCase.menuItems
            .bind(to: output.menuItems)
            .disposed(by: disposeBag)

        menuUseCase.errorMessage
            .bind(to: output.errorMessage)
            .disposed(by: disposeBag)

        orderUseCase.orderSuccess
            .bind(to: output.orderSuccess)
            .disposed(by: disposeBag)

        orderUseCase.errerMessage
            .bind(to: output.errorMessage)
            .disposed(by: disposeBag)

        cart
            .bind { cart in
                output.cancelButtonIsHidden.accept(cart.totalQuantity == 0)
                output.orderButtonIsEnabled.accept(cart.totalQuantity > 0)
            }
            .disposed(by: disposeBag)

        return output
    }
}
