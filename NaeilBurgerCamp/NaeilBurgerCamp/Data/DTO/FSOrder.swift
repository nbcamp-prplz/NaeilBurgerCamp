import Foundation

struct FSOrders: Decodable {
    let documents: [FSOrderDocument]
}

struct FSOrderDocument: Decodable {
    let name: String
    let fields: FSOrder
}

struct FSOrder: Decodable {
    let id: FSString
    let paymentDate: FSString
    let orderDetails: FSArray<FSMap<FSFields<FSOrderDetail>>>
}

struct FSOrderDetail: Decodable {
    let menuItemID: FSString
    let amount: FSInteger
}
