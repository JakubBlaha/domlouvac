import Foundation

class ProfileViewModel: ObservableObject {
    func logout() {
        KeychainWrapper.shared.removeAccessTokens()
    }
}
