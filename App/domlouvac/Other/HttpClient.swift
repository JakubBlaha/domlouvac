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

struct Authorization {
    public let authorizationHeader: String

    init(username: String, password: String) {
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()

        authorizationHeader = "Basic " + base64LoginString
    }

    init(token: String) {
        authorizationHeader = "Bearer " + token
    }
}

struct AnyResponse: Decodable {
}

struct EmptyData: Encodable {
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

    func fetch<T: Decodable>(endpoint: String, auth: Authorization) async throws -> T {
        return try await sendData(endpoint: endpoint, object: EmptyData(), httpMethod: HttpMethod.GET, auth: auth)
    }

    func sendData<T: Encodable, U: Decodable>(endpoint: String, object: T, httpMethod: HttpMethod, auth: Authorization? = nil) async throws -> U {
        var request = try URLRequest(url: getUrl(endpoint))

        request.httpMethod = httpMethod.rawValue
        request.addValue(MIMEType.JSON.rawValue,
                         forHTTPHeaderField: HttpHeaders.contentType.rawValue)

        if auth != nil {
            request.addValue(auth!.authorizationHeader, forHTTPHeaderField: "Authorization")
        }

        if type(of: object) != EmptyData.self {
            request.httpBody = try? JsonHelper.shared.encoder.encode(object)
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw HttpError.badResponse
        }

        let object: U

        do {
            object = try JsonHelper.shared.decoder.decode(U.self, from: data)
        } catch {
            print(error)

            throw HttpError.errorDecodingData
        }

        return object
    }

    func sendData<T: Encodable>(toEndpoint endpoint: String, object: T, httpMethod: HttpMethod, authorization: Authorization? = nil) async throws {
        let res: AnyResponse = try await sendData(
            endpoint: endpoint, object: object, httpMethod: httpMethod, auth: authorization)
    }

    func sendReqest(to endpoint: String, httpMethod: String, auth: Authorization? = nil) async throws {
        var request = try URLRequest(url: getUrl(endpoint))

        request.httpMethod = httpMethod
        request.addValue(MIMEType.JSON.rawValue,
                         forHTTPHeaderField: HttpHeaders.contentType.rawValue)

        if auth != nil {
            request.addValue(auth!.authorizationHeader, forHTTPHeaderField: "Authorization")
        }

        let (_, response) = try await URLSession.shared.data(for: request)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw HttpError.badResponse
        }
    }
}
