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
    var venueInfo: Driver<String>
//    let userLocation: Driver<CLLocation>
//    let authorized: Driver<Bool>
    
    // MARK: - Services
    var mediaPlayer: MediaController
    var locationService: LocationService
    var client: VenueAPIClient
    
    init(location: LocationService, media: MediaController, api: VenueAPIClient) {
        self.locationService = location
        self.client = api
        mediaPlayer = media
        
        areaName = locationService.areaName
        showMusicID = rxShowMusicID.asObservable()
        
        currentMediaItem = mediaPlayer.currentMediaItem
            .asDriver(onErrorJustReturn: .empty)
        
        playbackState = mediaPlayer.playbackState
            .asDriver(onErrorJustReturn: "Driver Error (playbackState): Could not find playback state")
        
        
        venueInfo = currentMediaItem.asObservable()
            .filter { $0.isSong }
            .map { song in song.media.artist! }
            .distinctUntilChanged()
            .map { ArtistEndpoint(artistName: $0) }
            .map { $0.request }
            //.debug()
            .flatMapLatest { request -> Observable<String> in
                // TODO: Refactor
                return URLSession.shared.rx.data(request: request)
                    .map { $0.convertTo(type: ArtistSearchResult.self) }
                    .errorOnNil()
                    .map { try $0.artistIdOrError() }
            }
            .map {  VenueEndpoint(artistID: $0).request }
            //.debug()
            .flatMapLatest { request in
                return URLSession.shared.rx.data(request: request)
                    .map { $0.convertTo(type: EventSearchResult.self) }
                    .errorOnNil()
                    .map { $0.resultsPage.results.event?.count.description ?? "0" } //String(data: $0, encoding: .utf8) ?? "NADA" }
            }
            .asDriver(onErrorRecover: { error in
                let errorMessage:String
                
                switch error {
                case ArtistSearchResult.DecodingError.noArtist:
                    errorMessage = "Error fetching venue artist: AristSearchResult"
                case ArtistSearchResult.DecodingError.noIdentifiers:
                    errorMessage = "Error fetching venue identifiers: AristSearchResult"
                default:
                    errorMessage = "Not an ArtistSearchResult error"
                }
                
                return Driver<String>.just(errorMessage)
            })
            //.asDriver(onErrorJustReturn: "Error fetching venue info")
            
        venueInfo
            .drive(onNext: { json in
                print()
                print("Venue count: \(json)")
            })

        
    }
}
