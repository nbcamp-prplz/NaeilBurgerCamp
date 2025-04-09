import Foundation

protocol OrderRepositoryProtocol {
    func placeOrder(for cart: Cart) async -> Result<Void, FSError>
}

class OrderRepository: OrderRepositoryProtocol {
    private let service: FirestoreService

    init(service: FirestoreService = FirestoreService()) {
        self.service = service
    }

    func placeOrder(for cart: Cart) async -> Result<Void, FSError> {
        //TODO: FirestoreServie.createOrder() 호출
        return .success(())
    }
}
