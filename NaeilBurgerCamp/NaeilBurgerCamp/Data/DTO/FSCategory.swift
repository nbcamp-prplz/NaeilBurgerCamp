import Foundation

struct FSCategories: Decodable {
    let documents: [FSCategoryDocument]
}

struct FSCategoryDocument: Decodable {
    let name: String
    let fields: FSCategory
}

struct FSCategory: Decodable {
    let id: FSString
    let title: FSString
    let priority: FSInteger
}
