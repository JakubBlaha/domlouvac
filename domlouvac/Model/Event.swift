//
//  Event.swift
//  domlouvac
//
//  Created by Jakub Bláha on 23.04.2024.
//

import Foundation
import SwiftUI
import CoreLocation

struct Event: Hashable, Codable, Identifiable {
    var id: Int;
    var name: String;
    var startTime: Date;
    var durationMinutes: Int;
    var imageUrl: String;
    var locationName: String;
    
    private var coordinates: Coordinates;
    
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: coordinates.latitude, longitude: coordinates.longitude
        )
    }
    
    struct Coordinates: Hashable, Codable {
        var latitude: Double
        var longitude: Double
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
}
