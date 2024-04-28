import Foundation

struct UserPublic: Decodable, Identifiable, Hashable {
    var id: UUID
    var name: String
}
