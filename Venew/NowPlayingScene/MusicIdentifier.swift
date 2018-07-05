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

protocol SongFinder {
    func startRecognition()
    
    
    var song: Driver<SongACR> { get }
    
    func handleState(_ state: String) -> Void
    func handleVolume(_ volume: Float) ->  Void
    func handleResult(_ result: String, resType: ACRCloudResultType) -> Void
}

class MusicIdentifier {
    var client: ACRCloudRecognition
    let bag = DisposeBag()
    
    var isListening: Driver<Bool>
    var song: Driver<SongACR>
    
    private var songResult = PublishSubject<SongACR>()
    private var isActive = BehaviorSubject<Bool>(value: false)
    
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
        
        song = songResult
            .debug()
            .asDriver(onErrorDriveWith: Driver.never())
        
        isListening = isActive
            .asDriver(onErrorJustReturn: false)
        
        _ = isActive
            .filter({ $0 == true })
            .subscribe(onNext: { [weak self] in
                self?.client.startRecordRec()
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
        isActive.onNext(true)
    }
    
    func handleResult(_ result: String, resType: ACRCloudResultType) -> Void {
        defer {
            self.client.stopRecordRec()
            self.isActive.onNext(false)
        }
        
        print(result)
        print(resType.rawValue)
        
        guard resType.rawValue > -1 else { return }
        
        DispatchQueue.main.async {
            if let data = result.data(using: .utf8) {
                let decoder = JSONDecoder()
                let song = try! decoder.decode(SongACR.self, from: data)
                self.songResult.onNext(song)
                print("OnNext")
            }
        }
    }
    
    func handleVolume(_ volume: Float) -> Void {
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
