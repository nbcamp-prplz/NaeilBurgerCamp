import Foundation

fileprivate enum FSPath: String {
    case categories
    case menuItems
    case orders
}

final class FirestoreService {
    private let projectID = "naeilburgercamp"
    private let databaseID = "(default)"

    private var baseURL: String {
        "https://firestore.googleapis.com/v1/projects/\(projectID)/databases/\(databaseID)/documents"
    }

    func fetchCategories() async -> Result<FSCategories, FSError> {
        await fetch(from: .categories, as: FSCategories.self)
    }

    func fetchMenuItems() async -> Result<FSMenuItems, FSError> {
        await fetch(from: .menuItems, as: FSMenuItems.self)
    }

    func fetchOrders() async -> Result<FSOrders, FSError> {
        await fetch(from: .orders, as: FSOrders.self)
    }

    func createOrder(_ order: FSOrderDocumentForCreation) async -> Result<Void, FSError> {
        await create(from: order, to: .orders)
    }
}

private extension FirestoreService {
    func fetch<T: Decodable>(from path: FSPath, as type: T.Type) async -> Result<T, FSError> {
        let urlString = "\(baseURL)/\(path)"
        guard let url = URL(string: urlString) else {
            return .failure(.invalidURL(urlString: urlString))
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse,
               !(200...299).contains(httpResponse.statusCode) {
                return .failure(.httpError(statusCode: httpResponse.statusCode))
            }

            guard !data.isEmpty else {
                return .failure(.noData)
            }

            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                return .success(result)
            } catch {
                return .failure(.decodingFailed(message: error.localizedDescription))
            }
        } catch {
            return .failure(.unknownError(message: error.localizedDescription))
        }
    }

    func create<T: Encodable>(from document: T, to path: FSPath) async -> Result<Void, FSError> {
        let urlString = "\(baseURL)/\(path)"
        guard let url = URL(string: urlString) else {
            return .failure(.invalidURL(urlString: urlString))
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(document)
            request.httpBody = jsonData
        } catch {
            return .failure(.encodingFailed(message: error.localizedDescription))
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse,
               !(200...299).contains(httpResponse.statusCode) {
                return .failure(.httpError(statusCode: httpResponse.statusCode))
            }

            guard !data.isEmpty else {
                return .failure(.noData)
            }

            return .success(())
        } catch {
            return .failure(.unknownError(message: error.localizedDescription))
        }
    }
}
