import Foundation

struct FSString: Decodable {
    let stringValue: String
}

struct FSInteger: Decodable {
    let integerValue: String
}

struct FSArray<T: Decodable>: Decodable {
    let arrayValue: FSArrayValue<T>
}

struct FSArrayValue<T: Decodable>: Decodable {
    let values: Array<T>
}

struct FSMap<T: Decodable>: Decodable {
    let mapValue: T
}

struct FSFields<T: Decodable>: Decodable {
    let fields: T
}
