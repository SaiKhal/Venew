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
    var showMusicID: Observable<Void> { get }
    var playbackState: Driver<String> { get }
    var currentMediaItem: Driver<MediaItem> { get }
    var areaName: Driver<String> { get }
}

protocol NowPlayingViewModelServices {
    var mediaPlayer: MPMusicPlayerController { get }
    var client: VenueAPIClient { get }
}

protocol NowPlayingViewModelType {
    var inputs: NowPlayingViewModelInputs { get }
    var outputs: NowPlayingViewModelOutputs { get }
    var services: NowPlayingViewModelServices { get }
}

extension MPMusicPlaybackState {
    var description: String {
        switch self {
        case .stopped:
            return "stopped"
        case .playing:
            return "playing"
        case .paused:
            return "paused"
        case .interrupted:
            return "interrupted"
        case .seekingForward:
            return "seeking forward"
        case .seekingBackward:
            return "seeking backwards"
        }
    }
}

final class NowPlayingViewModel: NowPlayingViewModelType, NowPlayingViewModelInputs, NowPlayingViewModelOutputs, NowPlayingViewModelServices {
    
    var showMusicID: Observable<Void>
    
    var inputs: NowPlayingViewModelInputs { return self }
    var outputs: NowPlayingViewModelOutputs { return self }
    var services: NowPlayingViewModelServices { return self }
    
    // MARK: - Inputs
    func play() {
        print(mediaPlayer.playbackState.description)
        if mediaPlayer.playbackState == .playing {
            mediaPlayer.pause()
        } else {
            mediaPlayer.play()
        }
    }
    
    func rewind() {
        mediaPlayer.skipToPreviousItem()
    }
    
    func next() {
        mediaPlayer.skipToNextItem()
    }
    
    func identifySong() {
        rxShowMusicID.onNext(())
    }
    
    // MARK: - Outputs
    let playbackState: Driver<String>
    let currentMediaItem: Driver<MediaItem>
//    let userLocation: Driver<CLLocation>
//    let authorized: Driver<Bool>
    let areaName: Driver<String>
    
    var venueInfo: Driver<String>
    
    // MARK: - Private
    var rxCurrentMediaItem: BehaviorSubject<MediaItem>
    var rxState: BehaviorSubject<String>
    var rxShowMusicID = PublishSubject<Void>()
    
    // MARK: - Services
    var mediaPlayer: MPMusicPlayerController
    var locationService: LocationService
    var client: VenueAPIClient

    init(locationService: LocationService) {
        self.locationService = locationService
        self.client = VenueAPIClient()
        
        mediaPlayer = MPMusicPlayerController.systemMusicPlayer
        mediaPlayer.beginGeneratingPlaybackNotifications()
        
        rxState = BehaviorSubject(value: mediaPlayer.playbackState.description)
        rxCurrentMediaItem = BehaviorSubject(value: mediaPlayer.mediaItem())
        
        currentMediaItem = rxCurrentMediaItem
            .asDriver(onErrorJustReturn: .empty)
        
        playbackState = rxState
            .asDriver(onErrorJustReturn: "Driver Error (playbackState): Could not find playback state")
        
        venueInfo = rxCurrentMediaItem
            .asObservable()
            .filter({ (musicItem) -> Bool in
                if case .song = musicItem {
                    return true
                } else {
                    return false
                }
            })
            .map { $0.media }
            .map { ArtistEndpoint(artistName: $0.albumArtist!) }
            .map { $0.request }
            .debug()
            .flatMapLatest { request -> Observable<String> in
                return URLSession.shared.rx.data(request: request)
                    .map { $0.convertTo(type: ArtistSearchResult.self) }
                    .errorOnNil()
                    .map { "\($0.resultsPage.results.artist.first!.id)" }
            }
            .asDriver(onErrorJustReturn: "Error fetching venue info")
            
            venueInfo
            .drive(onNext: { json in
                print(json)
            })

        areaName = locationService.areaName
        showMusicID = rxShowMusicID.asObservable()
        
        let notificationCenter = NotificationCenter.default
        
        //        Observe now playing item
        notificationCenter.addObserver(self,
                                       selector: #selector(handleMusicPlayerControllerNowPlayingItemDidChange),
                                       name: .MPMusicPlayerControllerNowPlayingItemDidChange,
                                       object: mediaPlayer)
        
        //        Observe playback state
        notificationCenter.addObserver(self,
                                       selector: #selector(handleMusicPlayerControllerPlaybackStateDidChange),
                                       name: .MPMusicPlayerControllerPlaybackStateDidChange,
                                       object: mediaPlayer)
        
    }
    
    
    
    
    // MARK: Notification Observing Methods
    @objc func handleMusicPlayerControllerNowPlayingItemDidChange() {
        rxCurrentMediaItem.onNext(MediaItem.song(mediaPlayer.nowPlayingItem!))
    }
    
    @objc func handleMusicPlayerControllerPlaybackStateDidChange() {
        rxState.onNext(mediaPlayer.playbackState.description)
    }
    
}

//final class MapViewModel2: MapViewModelType, MapViewModelInputs, MapViewModelOutputs, MapViewModelServices {
//
//
//    var tiredButtonDidTap = PublishSubject<MarkerType>()
//    var bathroomButtonDidTap = PublishSubject<MarkerType>()
//    var startButtonDidTap = PublishSubject<Void>()
//    var stopButtonDidTap = PublishSubject<Void>()
//
//    var inputs: MapViewModelInputs { return self }
//    var outputs: MapViewModelOutputs { return self }
//    var services: MapViewModelServices { return self }
//
//    var route: Driver<Mappable>
//
//    // MARK: - Services
//    var locationService: LocationProvider
//    let bag = DisposeBag()
//
//    var coordinates: Observable<CLLocation> {
//        return locationService.userLocations.asObservable().share()
//    }
//
//    var mapMarkers: Observable<MarkerType> {
//        return Observable.of(tiredButtonDidTap, bathroomButtonDidTap).merge()
//    }
//
//    // MARK: - State
//    var routes = [UUID: Mappable]()
//
//    // MARK: - Private Streams
//    var locationsRx = PublishSubject<[CLLocation]>()
//    var markerRx = PublishSubject<[MapMarker]>()
//
//    // MARK: - Init
//    public init(services: MapViewModelServices) {
//        // MARK: - Services
//        self.locationService = services.locationService
//
//        route = Observable
//            .combineLatest(locationsRx, markerRx)
//            .map({ (locations, markers) in
//                let route = Route(locations: locations, pins: markers)
//                return route
//            })
//            .asDriver(onErrorJustReturn: Route())
//
//        startButtonDidTap
//            .asObservable()
//            .subscribe(onNext: { _ in self.startRecording() })
//            .disposed(by: bag)
//
//        stopButtonDidTap
//            .asObservable()
//            .subscribe { _ in self.stopRecording() }
//            .disposed(by: bag)
//
//
//    }
//
//    // MARK: - Map Transformations
//    func startRecording() {
//        coordinates
//            .take(1)
//            .subscribe(onNext: { _ in self.clearState() })
//            .disposed(by: bag)
//
//        mapMarkers
//            .withLatestFrom(coordinates) { markerType, location in markerType.create(at: location) }
//            .takeUntil(stopButtonDidTap)
//            .scan([MapMarker]()) { list, marker in
//                return list + [marker]
//            }
//            .startWith([])
//            .subscribe(onNext: { mapMarkers in
//                self.markerRx.onNext(mapMarkers)
//            })
//            .disposed(by: bag)
//
//        coordinates
//            .takeUntil(stopButtonDidTap)
//            .scan([CLLocation]()) { list, coord in
//                return list + [coord]
//            }
//            .subscribe(onNext: { coords in
//                self.locationsRx.onNext(coords)
//            })
//            .disposed(by: bag)
//
//    }
//
//    func stopRecording() {
//        route
//            .asObservable()
//            .takeLast(1)
//            .subscribe(onNext: { route in
//                self.save(route: route)
//            })
//            .disposed(by: bag)
//    }
//
//    private func clearState() {
//        print("removing")
//
//    }
//
//    private func save(route: Mappable) {
//        let routeID = UUID()
//        routes[routeID] = route
//
//        print(routes.keys)
//    }
//
//}
//
//class MapViewModelDep: MapViewModelServices {
//    var locationService: LocationProvider
//
//    init(locationService: LocationProvider) {
//        self.locationService = locationService
//    }
//}

