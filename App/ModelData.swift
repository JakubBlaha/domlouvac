//
//  ModelData.swift
//  domlouvac
//
//  Created by Jakub Bláha on 23.04.2024.
//

import Foundation

var events: [Event] = load("eventData.json");

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

var groups: [Group] = [
    Group(id: 0, name: "Chabri"),
    Group(id: 0, name: "Netbound"),
]
