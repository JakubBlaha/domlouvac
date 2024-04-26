import Foundation

enum HttpMethod: String {
    case POST, GET, PUT, DELETE
}

enum MIMEType: String {
    case JSON = "application/json"
}

enum HttpHeaders: String {
    case contentType = "Content-Type"
}

enum HttpError: Error {
    case badURL, badResponse, errorDecodingData, invalidURL
}

class HttpClient {
    private let baseUrl: String

    required init(_ baseUrl: String) {
        self.baseUrl = baseUrl
    }

    static let shared = HttpClient("http://localhost:8080/")

    private func getUrl(_ endpoint: String) throws -> URL {
        guard let url = URL(string: baseUrl + endpoint) else {
            throw HttpError.badURL
        }

        return url
    }

    func fetch<T: Codable>(urlSegment: String) async throws -> [T] {
        let (data, response) = try await URLSession.shared.data(from: getUrl(urlSegment))

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw HttpError.badResponse
        }

        guard let object = try? JsonHelper.shared.decoder.decode([T].self, from: data) else {
            throw HttpError.errorDecodingData
        }
        return object
    }

    func sendData<T: Encodable>(toEndpoint endpoint: String, object: T, httpMethod: HttpMethod) async throws {
        var request = try URLRequest(url: getUrl(endpoint))

        request.httpMethod = httpMethod.rawValue
        request.addValue(MIMEType.JSON.rawValue,
                         forHTTPHeaderField: HttpHeaders.contentType.rawValue)

        request.httpBody = try? JsonHelper.shared.encoder.encode(object)

        let (_, response) = try await URLSession.shared.data(for: request)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw HttpError.badResponse
        }
    }

    func sendReqest(to endpoint: String, httpMethod: String) async throws {
        var request = try URLRequest(url: getUrl(endpoint))

        request.httpMethod = httpMethod
        request.addValue(MIMEType.JSON.rawValue,
                         forHTTPHeaderField: HttpHeaders.contentType.rawValue)

        let (_, response) = try await URLSession.shared.data(for: request)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw HttpError.badResponse
        }
    }
}
