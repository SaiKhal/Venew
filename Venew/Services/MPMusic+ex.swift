//
//  MPMusic+ex.swift
//  Venew
//
//  Created by Masai Young on 7/23/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import Foundation
import MediaPlayer

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
    
    var isSong: Bool {
        if case .song = self { return true }
        return false
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
