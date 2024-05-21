import Fluent
import Vapor

struct GroupController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let tokenProtected = routes.grouped(UserToken.authenticator())
        let groups = tokenProtected.grouped("groups")

        groups.get(use: { try await self.index(req: $0) })

        groups.get { req in
            try await self.get_my(req: req)
        }

        groups.post(use: { try await self.create(req: $0) })

        groups.post(
            "join", ":groupCode",
            use: { req in
                try await self.join(req: req)
            })

        groups.post(
            "leave", ":groupId",
            use: { req in
                try await self.leave(req: req)
            })

        groups.post(
            ":groupId", "events",
            use: { req in
                try await self.createEvent(req: req)
            })

        // groups.delete(":groupCode") { group in
        //     // self.delete(use: { try await self.delete(req: $0) })
        // }
    }

    func index(req: Request) async throws -> [Group] {
        try await Group.query(on: req.db).all()
    }

    func create(req: Request) async throws -> Group {
        try req.auth.require(User.self)

        try Group.Create.validate(content: req)
        let create = try req.content.decode(Group.Create.self)

        let newCode = String(format: "%06d", Int.random(in: 0...999_999))

        let group = Group(
            code: newCode,
            name: create.name
        )

        try await group.save(on: req.db)

        let user = req.auth.get(User.self)!
        try await group.$users.attach(user, on: req.db)

        return group
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let groupCode = req.parameters.get("groupCode") else {
            throw Abort(.badRequest)
        }

        guard let group = try await Group.query(on: req.db).filter(\.$code == groupCode).first()
        else {
            throw Abort(.notFound)
        }

        try await group.delete(on: req.db)
        return .noContent
    }

    func get_my(req: Request) async throws -> [Group] {
        let user = try req.auth.require(User.self)

        let userGroupIds = try await UserGroup.query(on: req.db).filter(\.$user.$id == user.id!)
            .all().map { group in
                group.$group.id
            }

        let groups = try await Group.query(on: req.db).with(\.$users)
            .filter(\.$id ~~ userGroupIds)
            .all()

        groups.forEach { group in
            group.users.forEach { user in
                user.email = ""
                user.passwordHash = ""
            }
        }

        return groups
    }

    func join(req: Request) async throws -> HTTPStatus {
        guard let groupCode = req.parameters.get("groupCode") else {
            throw Abort(.badRequest)
        }

        let user = try req.auth.require(User.self)

        guard let group = try await Group.query(on: req.db).filter(\.$code == groupCode).first()
        else {
            throw Abort(.notFound)
        }

        try await group.$users.attach(user, on: req.db)

        return .ok
    }

    func leave(req: Request) async throws -> HTTPStatus {
        guard let groupId = req.parameters.get("groupId") else {
            throw Abort(.badRequest)
        }

        guard let groupUUID = UUID(uuidString: groupId) else {
            throw Abort(.badRequest)
        }

        let user = try req.auth.require(User.self)

        guard let group = try await Group.query(on: req.db).filter(\.$id == groupUUID).first()
        else {
            throw Abort(.notFound)
        }

        try await group.$users.detach(user, on: req.db)

        return .ok
    }

    func createEvent(req: Request) async throws -> Event {
        let user = try req.auth.require(User.self)

        try Event.Create.validate(content: req)

        let create = try req.content.decode(Event.Create.self)

        guard let startTime = ISO8601DateFormatter().date(from: create.startTime) else {
            print("Invalid date")
            throw Abort(.badRequest)
        }

        guard let groupId = UUID(uuidString: create.groupId) else {
            print("Invalid UUID")
            throw Abort(.badRequest)
        }

        let event = Event(
            title: create.title,
            location: create.location,
            startTime: startTime,
            durationSeconds: create.durationSeconds,
            creatorId: user.id!,
            groupId: groupId
        )

        try await event.save(on: req.db)

        return event
    }
}
