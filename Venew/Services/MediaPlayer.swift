//
//  MediaPlayer.swift
//  Venew
//
//  Created by Masai Young on 7/19/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import Foundation
import MediaPlayer
import RxSwift
import RxCocoa

protocol MediaControllerInputs {
    func play()
    func rewind()
    func next()
}

protocol MediaControllerOutputs {
    var playbackState: Observable<String> { get }
    var currentMediaItem: Observable<MediaItem> { get }
}

protocol MediaControllerServices {
    var systemPlayer: MPMusicPlayerController & MPSystemMusicPlayerController { get }
}

typealias MediaController = MediaControllerInputs & MediaControllerOutputs & MediaControllerServices

class MediaPlayer: MediaController {
    
    // MARK: - Inputs
    func play() {
        if systemPlayer.playbackState == .playing {
            systemPlayer.pause()
        } else {
            systemPlayer.play()
        }
    }

    func rewind() {
        systemPlayer.skipToPreviousItem()
    }
    
    func next() {
        systemPlayer.skipToNextItem()
    }
    
    // MARK: - Outputs
    var playbackState: Observable<String> {
        return rxPlaybackState.asObservable()
    }
    
    var currentMediaItem: Observable<MediaItem> {
        return rxMediaItem.asObservable()
    }
    
    // MARK: - Service (Music Player)
    let systemPlayer: MPMusicPlayerController & MPSystemMusicPlayerController

    init() {
        systemPlayer = MPMusicPlayerController.systemMusicPlayer

        // MARK: - Internal Observables
        rxMediaItem = BehaviorSubject(value: systemPlayer.mediaItem())
        rxPlaybackState = BehaviorSubject(value: systemPlayer.playbackState.description)
        
        // MARK: - Notifications
        
        systemPlayer.beginGeneratingPlaybackNotifications()
        /*
            .beginGeneratingPlaybackNotifications() starts the generation of playback notifications that you must subscribe too manuaully.
         
                MPMusicPlayerControllerPlaybackStateDidChangeNotification
                MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                MPMusicPlayerControllerVolumeDidChangeNotification
         */
        
        let notificationCenter = NotificationCenter.default
        //        Observe now playing item
        notificationCenter.addObserver(self,
                                       selector: #selector(handleMusicPlayerControllerNowPlayingItemDidChange),
                                       name: .MPMusicPlayerControllerNowPlayingItemDidChange,
                                       object: systemPlayer)

        //        Observe playback state
        notificationCenter.addObserver(self,
                                       selector: #selector(handleMusicPlayerControllerPlaybackStateDidChange),
                                       name: .MPMusicPlayerControllerPlaybackStateDidChange,
                                       object: systemPlayer)
    }
    
    
    // MARK: Notification Response Methods
    var rxMediaItem: BehaviorSubject<MediaItem>
    @objc func handleMusicPlayerControllerNowPlayingItemDidChange() {
        rxMediaItem.onNext(systemPlayer.mediaItem())
    }
    
    var rxPlaybackState: BehaviorSubject<String>
    @objc func handleMusicPlayerControllerPlaybackStateDidChange() {
        rxPlaybackState.onNext(systemPlayer.playbackState.description)
    }
    
}


