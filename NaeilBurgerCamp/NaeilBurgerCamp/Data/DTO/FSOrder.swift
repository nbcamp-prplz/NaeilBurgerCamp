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
}

struct FSOrder: Codable {
    let id: FSString
    let paymentDate: FSString
    let orderDetails: FSArray<FSMap<FSFields<FSOrderDetail>>>
}

struct FSOrderDetail: Codable {
    let menuItemID: FSString
    let quantity: FSInteger
}
