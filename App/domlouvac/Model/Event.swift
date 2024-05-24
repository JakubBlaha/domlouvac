import CoreLocation
import Foundation
import SwiftUI

struct Duration: Hashable {
    var label: String
    var seconds: Int
}

enum EventDuration: CaseIterable {
    case MINS_15, MINS_30, MINS_45, HOURS_1, HOURS_2, HOURS_3, HOURS_4, HOURS_5, HOURS_6, HOURS_12,
         HOURS_24, DAYS_2, WEEK

    var value: Duration {
        switch self {
        case .MINS_15:
            return Duration(label: "15 minutes", seconds: 15 * 60)
        case .MINS_30:
            return Duration(label: "30 minutes", seconds: 30 * 60)
        case .MINS_45:
            return Duration(label: "45 minutes", seconds: 45 * 60)
        case .HOURS_1:
            return Duration(label: "1 hour", seconds: 1 * 60 * 60)
        case .HOURS_2:
            return Duration(label: "2 hours", seconds: 2 * 60 * 60)
        case .HOURS_3:
            return Duration(label: "3 hours", seconds: 3 * 60 * 60)
        case .HOURS_4:
            return Duration(label: "4 hours", seconds: 4 * 60 * 60)
        case .HOURS_5:
            return Duration(label: "5 hours", seconds: 5 * 60 * 60)
        case .HOURS_6:
            return Duration(label: "6 hours", seconds: 6 * 60 * 60)
        case .HOURS_12:
            return Duration(label: "12 hours", seconds: 12 * 60 * 60)
        case .HOURS_24:
            return Duration(label: "24 hours", seconds: 24 * 60 * 60)
        case .DAYS_2:
            return Duration(label: "2 days", seconds: 2 * 24 * 60 * 60)
        case .WEEK:
            return Duration(label: "1 week", seconds: 7 * 24 * 60 * 60)
        }
    }

    static var allCases: [EventDuration] {
        return [
            .MINS_15, .MINS_30, .MINS_45, .HOURS_1, .HOURS_2, .HOURS_3, .HOURS_4, .HOURS_5,
            .HOURS_6, .HOURS_12, .HOURS_24, .DAYS_2, .WEEK,
        ]
    }
}

struct Event: Hashable, Codable, Identifiable {
    var id: UUID
    var title: String
    var startTime: Date
    var durationSeconds: Int
    var location: String
    var isUserInterested: Bool
    var interestedUsers: [UserModel]
    var base64image: String

    var uiImage: UIImage? = nil

    mutating func decodeImage() {
        if let imageData = Data(base64Encoded: base64image),
           let uiImage = UIImage(data: imageData) {
            self.uiImage = uiImage
        } else {
            uiImage = nil
        }
    }

    mutating func setUiImage(uiImage: UIImage) {
        self.uiImage = uiImage
    }

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

    func getFormattedDuration() -> String {
        for eventDuration in EventDuration.allCases {
            if eventDuration.value.seconds == durationSeconds {
                return eventDuration.value.label
            }
        }

        return "\(durationSeconds) seconds"
    }

    enum CodingKeys: CodingKey {
        case id
        case title
        case startTime
        case durationSeconds
        case location
        case isUserInterested
        case interestedUsers
        case base64image
    }
}

let exampleEvent = Event(
    id: UUID(),
    title: "Test Event",
    startTime: Date.now,
    durationSeconds: 3600,
    location: "In the park",
    isUserInterested: false,
    interestedUsers: [UserModel(id: UUID(), name: "Interested user")],
    base64image: "iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAYAAACNMs+9AAAAFUlEQVR42mNk+M9Qz0AEYBxVSF+FAAhKDveksOjmAAAAAElFTkSuQmCC"
)
