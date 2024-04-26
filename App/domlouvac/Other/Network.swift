import Foundation

enum HTTPError: Error {
    case invalidResponse
    case requestFailed
}

class Network {
    private static let baseUrl = "http://localhost:8080"

    public static func postRegister(data: RegisterViewModel) async throws {
        let url = URL(string: baseUrl + "/users")!
        var req = URLRequest(url: url)
        
        req.httpMethod = "POST"
        req.httpBody = try JSONEncoder().encode(data)

        let (data, response) = try await URLSession.shared.data(for: req)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw HTTPError.invalidResponse
        }
    }
}
