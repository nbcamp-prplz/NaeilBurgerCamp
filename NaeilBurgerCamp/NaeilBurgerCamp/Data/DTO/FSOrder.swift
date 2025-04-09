import Foundation

struct FSOrders: Codable {
    let documents: [FSOrderDocument]
}

struct FSOrderDocument: Codable {
    let name: String
    let fields: FSOrder
}

struct FSOrderDocumentForCreation: Codable {
    let fields: FSOrder

    init(from fsOrder: FSOrder) {
        self.fields = fsOrder
    }
}

struct FSOrder: Codable {
    let id: FSString
    let paymentDate: FSString
    let orderDetails: FSArray<FSMap<FSFields<FSOrderDetail>>>

    init(from entity: Order) {
        self.id = FSString(stringValue: entity.id)
        self.paymentDate = FSString(stringValue: entity.paymentDate.isoString)
        self.orderDetails = FSArray(
            arrayValue: FSArrayValue(
                values: entity.orderDetails
                    .map {
                        FSMap(mapValue: FSFields(fields: FSOrderDetail(from: $0)))
                    }
            )
        )
    }
}

struct FSOrderDetail: Codable {
    let menuItemID: FSString
    let quantity: FSInteger

    init(from entity: OrderDetail) {
        self.menuItemID = FSString(stringValue: entity.menuItemID)
        self.quantity = FSInteger(integerValue: "\(entity.quantity)")
    }
}
