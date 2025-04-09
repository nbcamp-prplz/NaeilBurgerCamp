import Foundation

struct FSCategories: Codable {
    let documents: [FSCategoryDocument]
}

struct FSCategoryDocument: Codable {
    let name: String
    let fields: FSCategory
}

struct FSCategory: Codable {
    let id: FSString
    let title: FSString
    let sortOrder: FSInteger
}
