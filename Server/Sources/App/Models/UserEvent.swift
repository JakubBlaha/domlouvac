import Fluent
import Vapor

final class UserEvent: Model {
    static let schema = "user+event"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "user_id")
    var user: User

    @Parent(key: "event_id")
    var event: Event

    init() {}

    init(id: UUID? = nil, user: User, event: Event) throws {
        self.id = id
        self.$user.id = try user.requireID()
        self.$event.id = try event.requireID()
    }
}
