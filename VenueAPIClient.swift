//
//  VenueAPIClient.swift
//  
//
//  Created by Masai Young on 7/19/18.
//

import Foundation
import MediaPlayer

final class VenueAPIClient {
    func getArtistID(request: URLRequest) -> Observable<ArtistSearchResult> {
        return URLSession.shared.rx.data(request: request)
            .map { $0.convertTo(type: ArtistSearchResult.self) }
            .errorOnNil()
    }
    
    func getVenuesForArtist(_ id: ArtistID) {
        
    }
}

func foo() {
    let client = VenueAPIClient()
    client.get
}

extension MPMusicPlayerController {
    
}
