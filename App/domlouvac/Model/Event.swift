import CoreLocation
import Foundation
import SwiftUI

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
