import Fluent
import Vapor

final class Event: Model, Content, Sendable {
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

    @Field(key: "base64image")
    var base64image: String

    @Parent(key: "creator_id")
    var creator: User

    @Parent(key: "group_id")
    var group: Group

    @Siblings(through: UserEvent.self, from: \.$event, to: \.$user)
    public var users: [User]

    init() {}

    init(
        id: UUID? = nil,
        title: String,
        location: String,
        startTime: Date,
        durationSeconds: Int,
        base64image: String,
        creatorId: User.IDValue,
        groupId: Group.IDValue
    ) {
        self.id = id
        self.title = title
        self.location = location
        self.startTime = startTime
        self.durationSeconds = durationSeconds
        self.base64image = base64image
        self.$creator.id = creatorId
        self.$group.id = groupId
    }

    struct Create: Content, Validatable {
        var title: String
        var location: String
        var startTime: String
        var durationSeconds: Int
        var groupId: String
        var base64image: String

        static func validations(_ validations: inout Validations) {
            validations.add("title", as: String.self, is: !.empty)
            validations.add("location", as: String.self, is: !.empty)
            validations.add("startTime", as: Date.self)
            validations.add("durationSeconds", as: Int.self)
            validations.add("groupId", as: UUID.self)
            validations.add("base64image", as: String.self)
        }
    }

    struct Public: Content {
        var id: UUID
        var title: String
        var location: String
        var startTime: Date
        var durationSeconds: Int
        var interestedUsers: [InterestedUser]
        var isUserInterested: Bool
        var base64image: String

        struct InterestedUser: Content {
            var id: UUID
            var name: String
        }
    }

    func loadUsers(on: any Database) async throws {
        try await self.$users.load(on: on)
    }

    func loadGroup(on: any Database) async throws {
        try await self.$group.load(on: on)
    }

    func toPublic(reqUserId: UUID) async throws -> Event.Public {
        let interestedUsers = self.users.map({ user in
            Event.Public.InterestedUser(id: user.id!, name: user.name)
        })

        let userIsInterested = interestedUsers.contains(where: { interestedUser in
            interestedUser.id == reqUserId
        })

        return Event.Public(
            id: self.id!,
            title: self.title,
            location: self.location,
            startTime: self.startTime,
            durationSeconds: self.durationSeconds,
            interestedUsers: interestedUsers,
            isUserInterested: userIsInterested,
            base64image: self.base64image)
    }

    static func toPublic(events: [Event], reqUserId: UUID) async throws -> [Public] {
        var publicEvents: [Event.Public] = []

        for event in events {
            guard let publicEvent = try? await event.toPublic(reqUserId: reqUserId) else {
                throw Abort(.internalServerError)
            }

            publicEvents.append(publicEvent)
        }

        return publicEvents
    }

    static func getFromGroupWithUsers(groupId: UUID, on: any Database) async throws -> [Event] {
        let events = try await Event.query(on: on).filter(\.$group.$id == groupId)
            .with(\.$users).all()

        return events
    }

    static func getForUser(user: User, on: any Database) async throws -> [Event] {
        let events = try await Event.query(on: on).filter(
            \.$group.$id ~~ user.groups.map({ group in group.id! })
        )
        .all()

        return events
    }
}
