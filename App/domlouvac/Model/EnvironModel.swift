import Foundation

enum AuthError: Error {
    case tokenNotSetError
}

class EnvironModel: ObservableObject {
    @Published var accessToken: String?

    var tokenAuth: Authorization {
        print("accessToken")
        print(accessToken)

        return Authorization(token: accessToken!)
    }

    init() {
        accessToken = KeychainWrapper.shared.getAccessToken()
    }
}
