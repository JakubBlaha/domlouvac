import Fluent
import Vapor

final class Event: Model, Content {
    static let schema = "events"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @Field(key: "start_time")
    var startTime: Date

    @Field(key: "duration_seconds")
    var durationSeconds: Int

    @Parent(key: "creator_id")
    var creator: User

    @Parent(key: "group_id")
    var group: Group

    init() {}

    init(
        id: UUID? = nil, title: String, startTime: Date, durationSeconds: Int,
        creatorId: User.IDValue,
        groupId: Group.IDValue
    ) {
        self.id = id
        self.title = title
        self.startTime = startTime
        self.durationSeconds = durationSeconds
        self.$creator.id = creatorId
        self.$group.id = groupId
    }

    struct Create: Content, Validatable {
        var title: String
        var startTime: String
        var durationSeconds: Int
        var groupId: String

        static func validations(_ validations: inout Validations) {
            validations.add("title", as: String.self, is: !.empty)
            validations.add("startTime", as: Date.self)
            validations.add("durationSeconds", as: Int.self)
            validations.add("groupId", as: UUID.self)
        }
    }
}
