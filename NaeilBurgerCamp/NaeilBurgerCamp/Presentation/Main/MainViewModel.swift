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
        return output
    }
}

