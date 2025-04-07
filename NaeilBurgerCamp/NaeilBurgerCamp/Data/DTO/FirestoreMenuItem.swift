import Foundation

struct FirestoreMenuItems: Decodable {
    let documents: [FirestoreDocument]
}

struct FirestoreDocument: Decodable {
    let name: String
    let fields: FirestoreMenuItem
}

struct FirestoreMenuItem: Decodable {
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
