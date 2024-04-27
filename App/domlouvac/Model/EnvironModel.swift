import Foundation

class EnvironModel: ObservableObject {
    @Published var accessToken: String?

    init() {
        accessToken = KeychainWrapper.shared.getAccessToken()
    }
}
