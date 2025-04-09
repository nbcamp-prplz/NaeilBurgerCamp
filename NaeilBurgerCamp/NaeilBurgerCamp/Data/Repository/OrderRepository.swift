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
        let orderDetail = cart.details
            .map {
                OrderDetail(
                    menuItemID: $0.menuItem.id,
                    quantity: $0.quantity
                )
            }
        let order = Order(
            id: UUID().uuidString,
            paymentDate: Date(),
            orderDetails: orderDetail
        )

        return await service.createOrder(FSOrder(from: order))
    }
}
