import Fluent
import Vapor

final class Event: Model, Content {
    static let schema = "events"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @Field(key: "location")
    var location: String

    @Field(key: "start_time")
    var startTime: Date

    @Field(key: "duration_seconds")
    var durationSeconds: Int

    @Parent(key: "creator_id")
    var creator: User

    @Parent(key: "group_id")
    var group: Group

    @Siblings(through: UserEvent.self, from: \.$event, to: \.$user)
    public var users: [User]

    init() {}

    init(
        id: UUID? = nil, title: String, location: String, startTime: Date, durationSeconds: Int,
        creatorId: User.IDValue,
        groupId: Group.IDValue
    ) {
        self.id = id
        self.title = title
        self.location = location
        self.startTime = startTime
        self.durationSeconds = durationSeconds
        self.$creator.id = creatorId
        self.$group.id = groupId
    }

    struct Create: Content, Validatable {
        var title: String
        var location: String
        var startTime: String
        var durationSeconds: Int
        var groupId: String

        static func validations(_ validations: inout Validations) {
            validations.add("title", as: String.self, is: !.empty)
            validations.add("location", as: String.self, is: !.empty)
            validations.add("startTime", as: Date.self)
            validations.add("durationSeconds", as: Int.self)
            validations.add("groupId", as: UUID.self)
        }
    }

    struct Res: Content {
        var id: UUID
        var title: String
        var location: String
        var startTime: Date
        var durationSeconds: Int
        var interestedUsers: [InterestedUser]
        var isUserInterested: Bool

        struct InterestedUser: Content {
            var id: UUID
            var name: String
        }
    }
}
