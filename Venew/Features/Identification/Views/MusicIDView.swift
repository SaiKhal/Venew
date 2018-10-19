//
//  MusicIDView.swift
//  Venew
//
//  Created by Masai Young on 7/4/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SwiftSiriWaveformView

class MusicIDView: UIView {
    
    lazy var songNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Searching..."
        label.textColor = .white
        return label
    }()
    
    lazy var songArtistLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        return label
    }()
    
    lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    lazy var recordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Record", for: .normal)
        button.layer.cornerRadius = 5
        button.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        button.backgroundColor = Stylesheet.Colors.MainGreen
        return button
    }()
    
    lazy var audioWaveform: SwiftSiriWaveformView = {
        let waveform = SwiftSiriWaveformView()
        waveform.amplitude = 0.0
        waveform.backgroundColor = Stylesheet.Colors.MainGreen
        waveform.layer.cornerRadius = 10
        waveform.clipsToBounds = true
        return waveform
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func setup() {
        self.backgroundColor = Stylesheet.Colors.DarkGreen
        setupNameLabel()
        setupArtistLabel()
        setupRecordButton()
        setupSpinner()
        setupAudioWaveform()
    }
    
    func setupNameLabel() {
        self.addSubview(songNameLabel)
        songNameLabel.snp.makeConstraints { make in
            make.center.equalTo(self.snp.center)
        }
    }
    
    func setupArtistLabel() {
        self.addSubview(songArtistLabel)
        songArtistLabel.snp.makeConstraints { make in
            make.top.equalTo(songNameLabel.snp.bottom).offset(20)
            make.centerX.equalTo(self.snp.centerX)
        }
    }
    
    func setupRecordButton() {
        self.addSubview(recordButton)
        recordButton.snp.makeConstraints { make in
            make.top.equalTo(songArtistLabel.snp.bottom).offset(20)
            make.centerX.equalTo(self.snp.centerX)
        }
    }
    
    func setupSpinner() {
        self.addSubview(spinner)
        spinner.snp.makeConstraints { make in
            make.top.equalTo(recordButton.snp.bottom).offset(20)
            make.centerX.equalTo(recordButton.snp.centerX)
        }
    }
    
    func setupAudioWaveform() {
        self.addSubview(audioWaveform)
        audioWaveform.snp.makeConstraints { make in
            make.bottom.equalTo(songNameLabel.snp.top).offset(-20)
            make.centerX.equalTo(recordButton.snp.centerX)
            make.height.equalTo(self.snp.width).multipliedBy(0.7)
            make.width.equalTo(audioWaveform.snp.height)
        }
    }
}
