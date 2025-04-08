import Foundation

struct Order {
    let id: String
    let paymentDate: Date
    let orderDetails: OrderDetails

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
    let amount: Int

    init(from dto: FSOrderDetail) {
        self.menuItemID = dto.menuItemID.stringValue
        self.amount = Int(dto.amount.integerValue) ?? 0
    }
}

typealias OrderDetails = [OrderDetail]
