import Foundation

class EnvironModel: ObservableObject {
    @Published var accessToken: String?

    var tokenAuth: Authorization {
        return Authorization(token: accessToken!)
    }

    init() {
        accessToken = KeychainWrapper.shared.getAccessToken()
    }
}
