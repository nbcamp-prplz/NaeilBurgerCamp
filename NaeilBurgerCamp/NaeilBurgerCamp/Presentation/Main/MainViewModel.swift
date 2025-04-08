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
    
    struct Input {
        let categorySelected: Observable<Void>
        let menuItemSelected: Observable<Void>
        let increaseQuantityTapped: Observable<Void>
        let decreaseQuantityTapped: Observable<Void>
        let cancelTapped: Observable<Void>
        let orderTapped: Observable<Void>
    }
    struct Output {
        let orders = PublishRelay<Void>()
        let cancelResult = PublishRelay<Void>()
        let items = BehaviorRelay<[Item]>(value: [])
    }

    func transform(input: Input) -> Output {
        var output = Output()
        return output
    }
}

