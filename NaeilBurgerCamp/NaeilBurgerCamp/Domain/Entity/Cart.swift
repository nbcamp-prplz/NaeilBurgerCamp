import Foundation

struct Cart {
    struct Detail: Hashable {
        let menuItem: MenuItem
        var quantity: Int

        var totalPrice: Int {
            menuItem.price * quantity
        }
    }

    var details = [Detail]()

    var totalPrice: Int {
        details.map { $0.totalPrice }.reduce(0, +)
    }

    var totalQuantity: Int {
        details.map { $0.quantity }.reduce(0, +)
    }

    mutating func addMenuItem(with element: MenuItem) {
        if let index = details.firstIndex(where: { $0.menuItem.id == element.id }) {
            details[index].quantity += 1
        } else {
            details.append(Detail(menuItem: element, quantity: 1))
        }
    }

    mutating func removeMenuItem(with element: MenuItem) {
        if let index = details.firstIndex(where: { $0.menuItem.id == element.id }) {
            details[index].quantity -= 1
            if details[index].quantity == 0 {
                details.remove(at: index)
            }
        }
    }
}
