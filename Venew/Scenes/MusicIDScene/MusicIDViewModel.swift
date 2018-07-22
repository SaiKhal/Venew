//
//  MusicIDViewModel.swift
//  Venew
//
//  Created by Masai Young on 7/4/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol MusicIDViewModelInputs {
    func identifySong()
    func viewDidAppear()
    func viewDidDisappear()
}

protocol MusicIDViewModelOutputs {
    var isRecording: Driver<Bool> { get }
    var songName: Driver<String> { get }
    var songArtist: Driver<String> { get }
    var volume: Driver<Float> { get }
}

protocol MusicIDViewModelServices {
    var musicIdentifier: MusicIdentifier { get }
}

protocol MusicIDViewModelType {
    var inputs: MusicIDViewModelInputs { get }
    var outputs: MusicIDViewModelOutputs { get }
    var services: MusicIDViewModelServices { get }
}


final class MusicIDViewModel: MusicIDViewModelType, MusicIDViewModelInputs, MusicIDViewModelOutputs, MusicIDViewModelServices {
    
    func viewDidAppear() {
        musicIdentifier.startRecognition()
    }
    
    func viewDidDisappear() {
        musicIdentifier.stopRecognition()
    }
    
    func identifySong() {
        musicIdentifier.startRecognition()
    }
    
    var musicIdentifier: MusicIdentifier
    
    var isRecording: Driver<Bool>
    var songName: Driver<String>
    var volume: Driver<Float>
    var songArtist: Driver<String>
    
    var inputs: MusicIDViewModelInputs { return self }
    var outputs: MusicIDViewModelOutputs { return self }
    var services: MusicIDViewModelServices { return self }
    
    init(musicIDService: MusicIdentifier) {
        self.musicIdentifier = musicIDService
        
        volume = musicIdentifier.volume
        isRecording = musicIdentifier.isListening
        
        songName = musicIdentifier
            .song
            .map { result in
                switch result {
                case let .Success(song):
                    return song.metadata.music.first!.title
                case let .Failure(error):
                    return error.description
                }
            }
        
        songArtist = musicIdentifier
            .song
            .map { result in
                switch result {
                case let .Success(song):
                    return song.metadata.music.first!.artists.first!.name
                case let .Failure(error):
                    return error.description
                }
        }
        
        
        
        
    }
}
