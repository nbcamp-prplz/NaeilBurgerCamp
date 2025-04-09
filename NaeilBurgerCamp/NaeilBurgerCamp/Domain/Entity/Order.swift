import Foundation

struct Order {
    let id: String
    let paymentDate: Date
    let orderDetails: OrderDetails

    init(id: String, paymentDate: Date, orderDetails: OrderDetails) {
        self.id = id
        self.paymentDate = paymentDate
        self.orderDetails = orderDetails
    }

    init(from dto: FSOrder) {
        self.id = dto.id.stringValue
        self.paymentDate = Date(from: dto.paymentDate.stringValue) ?? Date(timeIntervalSince1970: 0)
        self.orderDetails = dto.orderDetails.arrayValue.values
            .map { OrderDetail(from: $0.mapValue.fields) }
    }
}

typealias Orders = [Order]

struct OrderDetail {
    let menuItemID: String
    let quantity: Int

    init(menuItemID: String, quantity: Int) {
        self.menuItemID = menuItemID
        self.quantity = quantity
    }

    init(from dto: FSOrderDetail) {
        self.menuItemID = dto.menuItemID.stringValue
        self.quantity = Int(dto.quantity.integerValue) ?? 0
    }
}

typealias OrderDetails = [OrderDetail]
