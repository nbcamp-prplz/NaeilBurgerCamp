import Foundation

final class FirestoreService {
    private let projectID = "naeilburgercamp"

    func fetchMenus() async -> FirestoreMenuItems? {
        let urlString = "https://firestore.googleapis.com/v1/projects/\(projectID)/databases/(default)/documents/menus"
        guard let url = URL(string: urlString) else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let result = try JSONDecoder().decode(FirestoreMenuItems.self, from: data)
            return result
        } catch {
            print("Firestore Error: \(error)")
            return nil
        }
    }
}
