import Foundation

struct Group: Hashable, Codable, Identifiable {
    var id: UUID
    var code: String
    var name: String
}
