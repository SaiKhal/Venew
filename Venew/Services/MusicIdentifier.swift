//
//  MusicIdentifier.swift
//  Venew
//
//  Created by Masai Young on 7/3/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MusicIdentifier {
    typealias MusicIDResultType = Result<SongACR, RecognitionError>
    enum RecognitionError: Error, CustomStringConvertible {
        case CouldNotFindSong
        case DriverError
        
        var description: String {
            switch self {
            case .CouldNotFindSong:
                return "Could not find song"
            case .DriverError:
                return "Sequence expeirence error"
            }
        }
    }
    
    var client: ACRCloudRecognition
    let bag = DisposeBag()
    
    var isListening: Driver<Bool>
    var song: Driver<MusicIDResultType>
    var volume: Driver<Float>
    
    private var rxSongResult = PublishSubject<MusicIDResultType>()
    private var rxIsActive = BehaviorSubject<Bool>(value: false)
    private var rxRecordingVolume = BehaviorSubject<Float>(value: 0.0)
    
    init() {
        let config = ACRCloudConfig()
        config.accessKey = "36341f0888cab7341e4fd18a2f449d88"
        config.accessSecret = "fZ7Wzp1IzcObI2RK8CmLktQS29rlwVtPhJeX8x5it"
        config.host = "identify-eu-west-1.acrcloud.com"
        //if you want to identify your offline db, set the recMode to "rec_mode_local"
        config.recMode = rec_mode_remote
        config.audioType = "recording"
        config.requestTimeout = 5
        config.protocol = "http"
        
        self.client = ACRCloudRecognition(config: config)
        
        if (config.recMode == rec_mode_local || config.recMode == rec_mode_both) {
            config.homedir = Bundle.main.resourcePath!.appending("/acrcloud_local_db");
        }
        
        song = rxSongResult
            .asDriver(onErrorJustReturn: Result.failure(.DriverError))
        
        isListening = rxIsActive
            .asDriver(onErrorJustReturn: false)
        
        volume = rxRecordingVolume
            .asDriver(onErrorJustReturn: -100.0)
        
        _ = rxIsActive
            .filter({ $0 == true })
            .subscribe(onNext: { [weak self] _ in
                self?.client.startRecordRec()
            })
        
        _ = rxIsActive
            .filter({ $0 == false })
            .subscribe(onNext: { [weak self] _ in
                self?.client.stopRecordRec()
            })
        
        config.stateBlock = { [weak self] state in
            self?.handleState(state!)
        }
        
        config.volumeBlock = { [weak self] volume in
            //do some animations with volume
            self?.handleVolume(volume)
        }
        
        config.resultBlock = { [weak self] result, resType in
            self?.handleResult(result!, resType:resType)
        }
        
        
    }
    
    func startRecognition() {
        rxIsActive.onNext(true)
    }
    
    func stopRecognition() {
        rxIsActive.onNext(false)
    }
    
    func handleResult(_ result: String, resType: ACRCloudResultType) -> Void {
        defer {
//            self.client.stopRecordRec()
            self.rxIsActive.onNext(false)
        }
        
        print(result)
        print(resType.rawValue)
        
        guard resType.rawValue > -1 else {
            self.rxSongResult.onNext(Result.failure(.CouldNotFindSong))
            return
        }
        
        DispatchQueue.main.async {
            if let data = result.data(using: .utf8) {
                let decoder = JSONDecoder()
                let song = try! decoder.decode(SongACR.self, from: data)
                self.rxSongResult.onNext(Result.success(song))
                print("OnNext")
            }
        }
    }
    
    func handleVolume(_ volume: Float) -> Void {
        rxRecordingVolume.onNext(volume)
        DispatchQueue.main.async {
            //self.volumeLabel.text = String(format: "Volume: %f", volume)
        }
    }
    
    func handleState(_ state: String) -> Void {
        DispatchQueue.main.async {
            //self.stateLabel.text = String(format:"State : %@",state)
        }
    }
}
