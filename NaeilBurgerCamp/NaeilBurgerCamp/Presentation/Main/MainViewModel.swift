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
    private let disposeBag = DisposeBag()
    private let selectedCategory = BehaviorRelay<Int>(value: 1)
    private let selectedMenuItem = BehaviorRelay<MenuItem?>(value: nil)
    private let quantity = BehaviorRelay<Int>(value: 0)
    
    struct Input {
        let categorySelected: Observable<Int>
        let menuItemSelected: Observable<MenuItem>
        let increaseQuantityTapped: Observable<Void>
        let decreaseQuantityTapped: Observable<Void>
        let cancelTapped: Observable<Void>
        let orderTapped: Observable<Void>
    }
    struct Output {
        let orderButtonIsDisable = PublishRelay<Bool>()
        let cancelButtonIsDisable = PublishRelay<Bool>() // 활성화, 비활성화
        let items = BehaviorRelay<[MenuItem]>(value: [])
        let quantity: Observable<Int>
        let orderResult = PublishRelay<Bool>()
    }
    
    func transform(input: Input) -> Output {
        var output = Output(quantity: quantity.asObservable())
        
        input.categorySelected
            .bind(to: selectedCategory)
            .disposed(by: disposeBag)
        
        input.menuItemSelected
            .subscribe(onNext: { [weak self] menuItem in
                self?.selectedMenuItem.accept(menuItem)
            })
            .disposed(by: disposeBag)
        
        input.increaseQuantityTapped
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let currentQuantity = self.quantity.value
                self.quantity.accept(currentQuantity + 1)
            })
            .disposed(by: disposeBag)
        
        input.decreaseQuantityTapped
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let currentQuantity = self.quantity.value
                if currentQuantity > 0 {
                    self.quantity.accept(currentQuantity - 1)
                }
            })
            .disposed(by: disposeBag)
        
        input.cancelTapped
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.quantity.accept(0)
                self.selectedMenuItem.accept(nil)
                output.cancelButtonIsDisable
                    .accept(quantity.value == 0) // menu + quantity -> 배열처리 후 isEmpty
            })
            .disposed(by: disposeBag)
        
        input.orderTapped
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                guard let selectedMenuItem = self.selectedMenuItem.value else { return } // 단일 상품만 다뤄지는 상태 -> 배열로 수정
                let orderDetails = DummyOrderDetails(menuItem: selectedMenuItem, quantity: self.quantity.value)
                let isSuccess = self.placeOrder(orderDetails: orderDetails)
                output.orderResult.accept(isSuccess)
                if isSuccess {
                    self.quantity.accept(0)
                    self.selectedMenuItem.accept(nil)
                }
            })
            .disposed(by: disposeBag)
        return output
    }
    private func placeOrder(orderDetails: DummyOrderDetails) -> Bool {
            print("주문 처리: \(orderDetails.menuItem.title), 수량: \(orderDetails.quantity)")
            return true
        }
}
