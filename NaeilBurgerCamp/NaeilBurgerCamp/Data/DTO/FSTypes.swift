import Foundation

struct FSString: Codable {
    let stringValue: String
}

struct FSInteger: Codable {
    let integerValue: String
}

struct FSArray<T: Codable>: Codable {
    let arrayValue: FSArrayValue<T>
}

struct FSArrayValue<T: Codable>: Codable {
    let values: Array<T>
}

struct FSMap<T: Codable>: Codable {
    let mapValue: T
}

struct FSFields<T: Codable>: Codable {
    let fields: T
}
