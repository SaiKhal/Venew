//
//  ArtistSearchResult.swift
//  Venew
//
//  Created by Masai Young on 7/19/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import Foundation

struct ArtistSearchResult: Codable {
    let resultsPage: ResultsPage
}

struct ResultsPage: Codable {
    let status: String
    let results: Results
    let perPage, page, totalEntries: Int
}

struct Results: Codable {
    let artist: [Artist]
}

struct Artist: Codable {
    let id: ArtistID
    let displayName, uri: String
    let identifier: [Identifier]
    let onTourUntil: String?
}

struct Identifier: Codable {
    let mbid, href, eventsHref, setlistsHref: String
}

struct ArtistID: Codable {
    let id: Int
}
