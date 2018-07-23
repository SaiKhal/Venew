//
//  MusicPlayer.swift
//  Venew
//
//  Created by Masai Young on 7/19/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import Foundation
import MediaPlayer
import RxSwift

enum MediaItem {
    case song(MPMediaItem)
    case empty
    
    var media: MPMediaItem {
        switch self {
        case let .song(media):
            return media
        default:
            return MPMediaItem()
        }
    }
}

extension MPMusicPlayerController {
    func mediaItem() -> MediaItem {
        if let song = self.nowPlayingItem {
            return MediaItem.song(song)
        } else {
            return MediaItem.empty
        }
    }
}

class MediaPlayer {
    
    let player = MPMusicPlayerController.systemMusicPlayer

    init() {
        mediaItemFrom = { player in
            if let nowPlayingMedia = player.nowPlayingItem {
                return MediaItem.song(nowPlayingMedia)
            } else {
                return MediaItem.empty
            }
        }
        
        mediaItem = BehaviorSubject(value: mediaItemFrom(player))
        playbackState = BehaviorSubject(value: player.playbackState)
        
        let notificationCenter = NotificationCenter.default
        //        Observe now playing item
        notificationCenter.addObserver(self,
                                       selector: #selector(handleMusicPlayerControllerNowPlayingItemDidChange),
                                       name: .MPMusicPlayerControllerNowPlayingItemDidChange,
                                       object: player)
        
        //        Observe playback state
        notificationCenter.addObserver(self,
                                       selector: #selector(handleMusicPlayerControllerPlaybackStateDidChange),
                                       name: .MPMusicPlayerControllerPlaybackStateDidChange,
                                       object: player)
    }
    
    // MARK: - Outputs
    var mediaItem: BehaviorSubject<MediaItem>
    var playbackState: BehaviorSubject<MPMusicPlaybackState>
    
    
    
    
    // MARK: Notification Observing Methods
    @objc func handleMusicPlayerControllerNowPlayingItemDidChange() {
        mediaItem.onNext(mediaItemFrom(player))
    }
    
    @objc func handleMusicPlayerControllerPlaybackStateDidChange() {
        playbackState.onNext(player.playbackState)
    }
    
    // MARK: - Helper Functions
    var mediaItemFrom: (MPMusicPlayerController) -> MediaItem
}


