import Foundation
import RxSwift
import RxCocoa

protocol MainViewModelProtocol {
    func transform(input: MainViewModel.Input) -> MainViewModel.Output
}

class MainViewModel: MainViewModelProtocol {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let upperMenuButtonTap: Observable<Void>
        let cellInteraction: Observable<Item>
        let increaseQuantityButtonTap: Observable<Void>
        let decreaseQuantityButtonTap: Observable<Void>
        let cancelButtonTap: Observable<Void>
        let orderButtonTap: Observable<Void>
    }
    
    struct Output {
        let upperMenuAction: Observable<Void>
        let cellInteractionResult: Observable<Item>
        let updateQuantity: Observable<[Item]>
        let cancelResult: Observable<Void>
        let orderCompletion: Observable<Result<Void, Error>>
    }
    
    func transform(input: Input) -> Output {
        <#code#>
    }
}
