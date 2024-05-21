import Fluent
import Vapor

struct EventController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let tokenProtected = routes.grouped(UserToken.authenticator())
        let events = tokenProtected.grouped("events")

        events.get(use: { try await self.index(req: $0) })

        // events.get { req in
        //     try await self.get_my(req: req)
        // }

        events.post(use: { try await self.create(req: $0) })

        // events.post(
        //     "join", ":groupCode",
        //     use: { req in
        //         try await self.join(req: req)
        //     })

        // events.delete(":groupCode") { group in
        //     // self.delete(use: { try await self.delete(req: $0) })
        // }
    }

    func index(req: Request) async throws -> [Event] {
        try await Event.query(on: req.db).all()
    }

    func create(req: Request) async throws -> Event {
        let user = try req.auth.require(User.self)

        try Event.Create.validate(content: req)

        let create = try req.content.decode(Event.Create.self)

        guard let startTime = ISO8601DateFormatter().date(from: create.startTime) else {
            throw Abort(.badRequest)
        }

        guard let groupId = UUID(uuidString: create.groupId) else {
            throw Abort(.badRequest)
        }

        let event = Event(
            title: create.title,
            startTime: startTime,
            durationSeconds: create.durationSeconds,
            creatorId: user.id!,
            groupId: groupId
        )

        try await event.save(on: req.db)

        return event
    }

    // func delete(req: Request) async throws -> HTTPStatus {
    //     guard let groupCode = req.parameters.get("groupCode") else {
    //         throw Abort(.badRequest)
    //     }

    //     guard let group = try await Group.query(on: req.db).filter(\.$code == groupCode).first()
    //     else {
    //         throw Abort(.notFound)
    //     }

    //     try await group.delete(on: req.db)
    //     return .noContent
    // }

    // func join(req: Request) async throws -> HTTPStatus {
    //     guard let groupCode = req.parameters.get("groupCode") else {
    //         throw Abort(.badRequest)
    //     }

    //     let user = try req.auth.require(User.self)

    //     guard let group = try await Group.query(on: req.db).filter(\.$code == groupCode).first()
    //     else {
    //         throw Abort(.notFound)
    //     }

    //     try await group.$users.attach(user, on: req.db)

    //     return .ok
    // }
}
