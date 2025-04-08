import Foundation
import RxSwift
import RxCocoa

protocol MainViewModelProtocol: AnyObject {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

final class MainViewModel: MainViewModelProtocol {
    private let disposeBag = DisposeBag()
    private let selectedCategory = BehaviorRelay<Int>(value: 1)
    private let selectedMenuItem = PublishRelay<Item>()
    private let quantity = BehaviorRelay<Int>(value: 0)
    
    struct Input {
        let categorySelected: Observable<Int>
        let menuItemSelected: Observable<Item>
        let increaseQuantityTapped: Observable<Void>
        let decreaseQuantityTapped: Observable<Void>
        let cancelTapped: Observable<Void>
        let orderTapped: Observable<Void>
    }
    struct Output {
        let orders = PublishRelay<Void>()
        let cancelResult = PublishRelay<Void>()
        let items = BehaviorRelay<[Item]>(value: [])
        let quantity: Observable<Int>
    }
    
    func transform(input: Input) -> Output {
        var output = Output(quantity: quantity.asObservable())
        
        input.categorySelected
            .bind(to: selectedCategory)
            .disposed(by: disposeBag)
        
        input.menuItemSelected
            .bind(to: selectedMenuItem)
            .disposed(by: disposeBag)
        
        input.increaseQuantityTapped
            .subscribe(onNext: { [weak self] in
                let currentQuantity = self?.quantity.value ?? 0
                self?.quantity.accept(currentQuantity + 1)
            })
            .disposed(by: disposeBag)
        
        input.decreaseQuantityTapped
            .subscribe(onNext: { [weak self] in
                let currentQuantity = self?.quantity.value ?? 0
                if currentQuantity > 0 {
                    self?.quantity.accept(currentQuantity - 1)
                }
            })
            .disposed(by: disposeBag)
        
        input.cancelTapped
            .subscribe(onNext: { [weak self] in
                self?.quantity.accept(0)
                output.cancelResult.accept(())
            })
            .disposed(by: disposeBag)
        
        input.orderTapped
            .subscribe(onNext: { [weak self] in
                
                output.orders.accept(())
            })
            .disposed(by: disposeBag)
        
        return output
    }
}

