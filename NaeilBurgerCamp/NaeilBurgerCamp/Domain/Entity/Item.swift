import Foundation

struct Item: Decodable {
    let id: Int
    let category: String // (단품, 사이드, 음료)
    let title: String
    let imageURL: String
    let price: Int
}
