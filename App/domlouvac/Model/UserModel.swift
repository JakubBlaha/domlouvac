import Foundation

struct UserModel: Hashable, Codable, Identifiable {
    var id: UUID
    var name: String
}
