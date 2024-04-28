import Foundation

enum AuthError: Error {
    case tokenNotSetError
}

class EnvironModel: ObservableObject {
    @Published var accessToken: String?

    var tokenAuth: Authorization {
        get throws {
            print(accessToken)

            if accessToken == nil {
                throw AuthError.tokenNotSetError
            }

            return Authorization(token: accessToken!)
        }
    }

    init() {
        accessToken = KeychainWrapper.shared.getAccessToken()
    }
}
