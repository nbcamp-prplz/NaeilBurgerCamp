import Foundation

final class FirestoreService {
    private let projectID = "naeilburgercamp"
    private let databaseID = "(default)"

    private var baseURL: String {
        "https://firestore.googleapis.com/v1/projects/\(projectID)/databases/\(databaseID)/documents"
    }

    func fetchCategories() async -> FSCategories? {
        let urlString = "\(baseURL)/categories"
        guard let url = URL(string: urlString) else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let result = try JSONDecoder().decode(FSCategories.self, from: data)
            return result
        } catch {
            print("Firestore Error: \(error)")
            return nil
        }
    }

    func fetchMenuItems() async -> FSMenuItems? {
        let urlString = "\(baseURL)/menuItems"
        guard let url = URL(string: urlString) else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let result = try JSONDecoder().decode(FSMenuItems.self, from: data)
            return result
        } catch {
            print("Firestore Error: \(error)")
            return nil
        }
    }

    func fetchOrders() async -> FSOrders? {
        let urlString = "\(baseURL)/orders"
        guard let url = URL(string: urlString) else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let result = try JSONDecoder().decode(FSOrders.self, from: data)
            return result
        } catch {
            print("Firestore Error: \(error)")
            return nil
        }
    }
}
