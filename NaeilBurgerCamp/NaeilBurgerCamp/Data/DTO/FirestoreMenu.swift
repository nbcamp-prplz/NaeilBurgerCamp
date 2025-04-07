import Foundation

struct FirestoreMenus: Decodable {
    let documents: [FirestoreDocument]
}

struct FirestoreDocument: Decodable {
    let name: String
    let fields: FirestoreMenu
}

struct FirestoreMenu: Decodable {
    let title: FirestoreString
    let category: FirestoreString
    let price: FirestoreInteger
}

struct FirestoreString: Decodable {
    let stringValue: String
}

struct FirestoreInteger: Decodable {
    let integerValue: String
}
