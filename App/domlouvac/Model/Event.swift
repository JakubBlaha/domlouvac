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
    var interestedUsers: [InterestedUser]

    struct InterestedUser: Codable, Hashable, Identifiable {
        var id: UUID
        var name: String
    }

//    private var coordinates: Coordinates

//    var locationCoordinate: CLLocationCoordinate2D {
//        CLLocationCoordinate2D(
//            latitude: coordinates.latitude, longitude: coordinates.longitude
//        )
//    }

//    struct Coordinates: Hashable, Codable {
//        var latitude: Double
//        var longitude: Double
//    }

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
    interestedUsers: [Event.InterestedUser(id: UUID(), name: "Interested user")]
)
