import Foundation
import RxSwift

protocol OrderUseCaseProtocol {
    func placeOrder(for cart: Cart) async
}

class OrderUseCase: OrderUseCaseProtocol {
    private let repository: OrderRepositoryProtocol
    let orderSuccess = PublishSubject<Void>()
    let errerMessage = PublishSubject<String>()

    init(repository: OrderRepositoryProtocol = OrderRepository()) {
        self.repository = repository
    }

    func placeOrder(for cart: Cart) async {
        let result = await repository.placeOrder(for: cart)
        switch result {
        case .success:
            self.orderSuccess.onNext(())
        case .failure(let error):
            errerMessage.onNext(error.errorDescription ?? error.localizedDescription)
        }
    }
}
