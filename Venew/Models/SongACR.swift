//
//  SongACR.swift
//  Venew
//
//  Created by Masai Young on 7/3/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import Foundation

struct SongACR: Codable {
    let status: Status
    let metadata: Metadata
    let resultType: Int
    
    enum CodingKeys: String, CodingKey {
        case status, metadata
        case resultType = "result_type"
    }
}

struct Metadata: Codable {
    let playedDuration: Int?
    let music: [Music]
    let timestampUTC: String
    
    enum CodingKeys: String, CodingKey {
        case playedDuration = "played_duration"
        case music
        case timestampUTC = "timestamp_utc"
    }
}

struct Music: Codable {
    let externalIDS: [String: String]
    let sampleBeginTimeOffsetMS, sampleEndTimeOffsetMS: String?
    let label: String
    let externalMetadata: ExternalMetadata
    let playOffsetMS: Int
    let artists: [MusicAlbum]
    let releaseDate: String
    let title: String
    let durationMS: Int
    let album: MusicAlbum
    let acrid: String
    let resultFrom: Int
    let dbBeginTimeOffsetMS, dbEndTimeOffsetMS: String?
    let score: Int
    
    enum CodingKeys: String, CodingKey {
        case externalIDS = "external_ids"
        case sampleBeginTimeOffsetMS = "sample_begin_time_offset_ms"
        case label
        case externalMetadata = "external_metadata"
        case playOffsetMS = "play_offset_ms"
        case artists
        case sampleEndTimeOffsetMS = "sample_end_time_offset_ms"
        case releaseDate = "release_date"
        case title
        case dbEndTimeOffsetMS = "db_end_time_offset_ms"
        case durationMS = "duration_ms"
        case album, acrid
        case resultFrom = "result_from"
        case dbBeginTimeOffsetMS = "db_begin_time_offset_ms"
        case score
    }
}

struct MusicAlbum: Codable {
    let name: String
}

struct ExternalMetadata: Codable {
    let spotify: Spotify
}

struct Spotify: Codable {
    let album: TrackClass
    let artists: [TrackClass]
    let track: TrackClass
}

struct TrackClass: Codable {
    let id: String
}

struct Status: Codable {
    let msg: String
    let code: Int
    let version: String
}
