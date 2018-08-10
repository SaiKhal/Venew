//
//  ArtistSearchResult.swift
//  Venew
//
//  Created by Masai Young on 7/19/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import Foundation

struct ArtistSearchResult: Codable {
    enum DecodingError: Error {
        case noArtist
        case noIdentifiers
    }
    
    let resultsPage: ArtistResultsPage
    
    func artistIdOrError() -> Result<String, DecodingError> {
        guard let artist = resultsPage.results.artist, !artist.isEmpty else {
            return .failure(DecodingError.noArtist)
        }
        
        guard let identifiers = artist.first?.identifier, !identifiers.isEmpty else {
            return .failure(DecodingError.noIdentifiers)
        }
        
        return .success(identifiers.first!.mbid)
    }
}

struct ArtistResultsPage: Codable {
    let status: String
    let results: ArtistResults
    let perPage, page, totalEntries: Int
}

struct ArtistResults: Codable {
    let artist: [Artist]?
}

struct Artist: Codable {
    let id: Int
    let displayName, uri: String
    let identifier: [ArtistIdentifier]
    let onTourUntil: String?
}

struct ArtistIdentifier: Codable {
    let mbid, href, eventsHref, setlistsHref: String
}

struct ArtistID {
    let id: Int
}
