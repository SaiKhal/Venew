//
//  ViewModelType.swift
//  DogWalk
//
//  Created by Masai Young on 5/31/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxOptional
import CoreLocation
import MediaPlayer

protocol NowPlayingViewModelInputs {
    func play()
    func rewind()
    func next()
    func identifySong()
}

protocol NowPlayingViewModelOutputs {
    var playbackState: Driver<String> { get }
    var currentMediaItem: Driver<MediaItem> { get }
    var areaName: Driver<String> { get }
    var showMusicID: Observable<Void> { get }
    var venueInfo: Driver<String> { get }
}

protocol NowPlayingViewModelServices {
    var mediaPlayer: MediaController { get }
    var client: VenueAPIClient { get }
}

protocol NowPlayingViewModelType {
    var inputs: NowPlayingViewModelInputs { get }
    var outputs: NowPlayingViewModelOutputs { get }
    var services: NowPlayingViewModelServices { get }
}



final class NowPlayingViewModel: NowPlayingViewModelType, NowPlayingViewModelInputs, NowPlayingViewModelOutputs, NowPlayingViewModelServices {
    
    var inputs: NowPlayingViewModelInputs { return self }
    var outputs: NowPlayingViewModelOutputs { return self }
    var services: NowPlayingViewModelServices { return self }
    
    // MARK: - Inputs
    // Media Player
    func play() {
        mediaPlayer.play()
    }
    
    func rewind() {
        mediaPlayer.rewind()
    }
    
    func next() {
        mediaPlayer.next()
    }
    
    // Navigation
    var rxShowMusicID = PublishSubject<Void>()
    var showMusicID: Observable<Void>
    func identifySong() {
        rxShowMusicID.onNext(())
    }
    
    // MARK: - Outputs
    let playbackState: Driver<String>
    let currentMediaItem: Driver<MediaItem>
    let areaName: Driver<String>
    let venueInfo: Driver<String>
    //    let userLocation: Driver<CLLocation>
    //    let authorized: Driver<Bool>
    
    // MARK: - Services
    var mediaPlayer: MediaController
    var locationService: LocationService
    var client: VenueAPIClient
    
    init(location: LocationService, media: MediaController, api: VenueAPIClient) {
        locationService = location
        client = api
        mediaPlayer = media
        
        areaName = locationService.areaName
        showMusicID = rxShowMusicID.asObservable()
        
        playbackState = mediaPlayer.playbackState
            .asDriver(onErrorJustReturn: "Driver Error (playbackState): Could not find playback state")
        
        currentMediaItem = mediaPlayer.currentMediaItem
            .asDriver(onErrorJustReturn: .empty)
        
        var venueLabelString: (Int) -> String = { venueCount in
            switch venueCount {
            case 0:
                return "No shows!"
            case 1:
                return "One show! Check it out."
            case 2...:
                return "Ayy!! We found \(venueCount) shows."
            default:
                return "We have a problem boss."
            }
        }
        
        let mediaArtist = currentMediaItem.asObservable()
            .filter { $0.isSong }
            .map { song in song.media.artist! }
        
        let artistID = mediaArtist
            .distinctUntilChanged()
            .map { ArtistEndpoint(artistName: $0).request }
            .flatMapLatest { request -> Observable<String> in
                // TODO: Refactor
                return URLSession.shared.rx.data(request: request)
                    .map { $0.convertToObject(type: ArtistSearchResult.self) }
                    .map { $0.value }
                    .errorOnNil()
                    .map { $0.artistIdOrError() }
                    .map { $0.value }
                    .errorOnNil()
        }
        
        venueInfo = artistID
            .map { VenueEndpoint(artistID: $0).request }
            .flatMapLatest { request in
                return URLSession.shared.rx.data(request: request)
                    .map { $0.convertToObject(type: EventSearchResult.self).value }
                    .errorOnNil()
                    .map { $0.resultsPage.results.event?.count ?? 0 } }
            .map (venueLabelString)
            .asDriver(onErrorJustReturn: "Error fetching venue info")
        
        venueInfo
            .drive(onNext: { json in
                print()
                print("Venue count: \(json)")
            })
    }

}
