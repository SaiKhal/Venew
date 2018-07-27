//
//  Events.swift
//  Venew
//
//  Created by Masai Young on 7/24/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import Foundation

struct EventSearchResult: Codable {
    let resultsPage: EventsResultsPage
}

struct EventsResultsPage: Codable {
    let results: EventResults
    let status: String
}

struct EventResults: Codable {
    let event: [Event]?
}

struct Event: Codable {
    let location: Location
    let popularity: Double
    let uri, displayName: String
    let id: Int
    let type: String
    let start: Start
    let ageRestriction: String?
    let performance: [Performance]
    let venue: Venue
    let status: String
}

struct Location: Codable {
    let city: String?
    let lng, lat: Double
}

struct Performance: Codable {
    let artist: City?
    let displayName: String
    let billingIndex, id: Int
    let billing: String
}

struct City: Codable {
    let uri, displayName: String
    let id: Int
    let identifier: [EventIdentifier]?
    let country: Country?
}

struct Country: Codable {
    let displayName: String
}

struct EventIdentifier: Codable {
    let href, mbid: String
}

struct Start: Codable {
    let time, datetime: String?
    let date: String
}

struct Venue: Codable {
    let metroArea, city: City?
    let zip, street, website, phone: String?
    let lat, lng: Double?
    let uri: String?
    let displayName: String
    let id: Int?
    let capacity: Int?
    let description: String?
}
