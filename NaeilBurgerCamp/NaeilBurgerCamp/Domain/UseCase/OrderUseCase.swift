import Foundation
import RxSwift

protocol OrderUseCaseProtocol {
    func placeOrder(for cart: Cart) async
}

class OrderUseCase: OrderUseCaseProtocol {
    private let repository: OrderRepositoryProtocol
    let isOrderSuccess = PublishSubject<Bool>()
    let errerMessage = PublishSubject<String>()

    init(repository: OrderRepositoryProtocol = OrderRepository()) {
        self.repository = repository
    }

    func placeOrder(for cart: Cart) async {
        let result = await repository.placeOrder(for: cart)
        switch result {
        case .success(let isOrderSuccess):
            self.isOrderSuccess.onNext(isOrderSuccess)
        case .failure(let error):
            errerMessage.onNext(error.errorDescription ?? error.localizedDescription)
        }
    }
}
