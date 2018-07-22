//
//  APIEndpoint.swift
//  Venew
//
//  Created by Masai Young on 7/19/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import Foundation

protocol APIEndpoint {
    var apiKey: String { get }
    var baseURL: URL { get}
    var path: String { get }
    var parameters: [String:String] { get }
    var request: URLRequest { get }
}

struct ArtistEndpoint: APIEndpoint {
    
    var artistName: String
    init(artistName: String) {
        self.artistName = artistName
    }
    
    var apiKey: String { return "pywHRmWTw8mGlA74" }
    var baseURL: URL { return URL(string: "https://api.songkick.com/api/3.0")! }
    var path: String { return "/search/artists.json" }
    var parameters: [String : String] {
        return ["apikey": apiKey,
                "query": artistName]
    }
    
    var request: URLRequest {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
            fatalError("Artist base url is wrong")
        }
        
        components.queryItems = parameters.map {
            URLQueryItem(name: $0, value: $1)
        }
        
        guard let url = components.url else {
            fatalError("Could not create artist url")
        }
        
        return URLRequest(url: url)
    }
    
}

struct VenueEndpoint: APIEndpoint {
    // https://api.songkick.com/api/3.0/artists/mbid:9b64b01a-42d0-4137-bbe1-85e4cf60d468/calendar.json?apikey=pywHRmWTw8mGlA74
    
    var artistID: String
    init(artistID: String) {
        self.artistID = artistID
    }
    
    var apiKey: String { return "pywHRmWTw8mGlA74" }
    var baseURL: URL { return URL(string: "https://api.songkick.com/api/3.0")! }
    var path: String { return "/artists/mbid:\(artistID)/calendar.json" }
    
    var parameters: [String : String] {
        return ["apikey": apiKey]
    }
    
    var request: URLRequest {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
            fatalError("Venue base url is wrong")
        }
        
        components.queryItems = parameters.map {
            URLQueryItem(name: $0, value: $1)
        }
        
        guard let url = components.url else {
            fatalError("Could not create venue url")
        }
        
        return URLRequest(url: url)
    }
    
}

