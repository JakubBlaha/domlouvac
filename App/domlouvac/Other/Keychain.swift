import Foundation

enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}

class KeychainWrapper {
    static let shared = KeychainWrapper()

    let account = "user"

    func storeAccessToken(token: String) throws {
        let key = token.data(using: String.Encoding.utf8)!

        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecValueData as String: key,
        ]

        let status = SecItemAdd(query as CFDictionary, nil)

        guard status == errSecSuccess else {
            print("Keychain error")

            throw KeychainError.unhandledError(status: status)
        }
    }

    func getAccessToken() -> String? {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status != errSecItemNotFound else { return nil }
        guard status == errSecSuccess else {
            print("Unhandled error")
            return nil
        }

        guard let existingItem = item as? [String: Any],
              let passwordData = existingItem[kSecValueData as String] as? Data,
              let password = String(data: passwordData, encoding: String.Encoding.utf8),
              let account = existingItem[kSecAttrAccount as String] as? String
        else {
//            throw KeychainError.unexpectedPasswordData
            print("unexpected password data")

            return nil
        }

        return password
    }

    func removeAccessTokens() {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword]

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
//            throw KeychainError.unhandledError(status: status)
            print("item not found")
            return
        }
    }
}
