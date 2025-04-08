import Foundation
import RxSwift
import RxCocoa

protocol MainViewModelProtocol: AnyObject {
    associatedtype Input
    associatedtype Output
    var output: Output { get }
    func transform(input: Input)
}

final class MainViewModel: MainViewModelProtocol {
    private let disposeBag = DisposeBag()
    var output: Output
    
    struct Input {}
    struct Output {}
    
    func transform(input: Input) {}
}


