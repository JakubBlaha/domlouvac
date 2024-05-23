import CoreLocation
import Foundation
import SwiftUI

struct Event: Hashable, Codable, Identifiable {
    var id: UUID
//    var creator: UUID
//    var group: UUID
    var title: String
    var startTime: Date
    var durationSeconds: Int
//    var imageUrl: String
    var location: String
    var isUserInterested: Bool
    var interestedUsers: [UserModel]

    func getFormattedDate() -> String {
        let formatter = DateFormatter()

        formatter.dateFormat = "dd.MM.yyyy"

        let startString = formatter.string(from: startTime)

        return startString
    }

    func getFormattedStartTime() -> String {
        let formatter = DateFormatter()

        formatter.dateFormat = "hh:mm a"

        let startString = formatter.string(from: startTime)

        return startString
    }
}

let exampleEvent = Event(
    id: UUID(),
    title: "Test Event",
    startTime: Date.now,
    durationSeconds: 3600,
    location: "In the park",
    isUserInterested: false,
    interestedUsers: [UserModel(id: UUID(), name: "Interested user")]
)
