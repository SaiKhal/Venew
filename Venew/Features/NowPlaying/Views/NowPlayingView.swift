//
//  NowPlayingView.swift
//  Venew
//
//  Created by Masai Young on 7/2/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import UIKit
import SnapKit

class NowPlayingView: UIView {

    lazy var imageview: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = Stylesheet.Colors.Navy
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    lazy var currentArtistLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    lazy var currentSongLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    lazy var locailityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    lazy var venueInfoButton: UIButton = {
        let button = UIButton()
        button.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        button.layer.cornerRadius = 5
        button.backgroundColor = Stylesheet.Colors.DarkGreen
        return button
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named:"forwardIcon")!, for: .normal)
        return button
    }()
    
    lazy var rewindButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named:"rewindIcon")!, for: .normal)
        return button
    }()
    
    lazy var recordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Record", for: .normal)
        button.backgroundColor = Stylesheet.Colors.DarkGreen
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        return button
    }()
    
    lazy var recordingIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private func setup() {
        self.backgroundColor = Stylesheet.Colors.MainGreen
        setupImageView()
        setupSongLabel()
        setupArtistLabel()
        setupMediaControllerButtons()
        setupLocalityLabel()
        setupRecordButton()
        setupRecordingIndicator()
        setupVenueInfoButton()
    }
    
    private func setupImageView() {
        self.addSubview(imageview)
        imageview.snp.makeConstraints { make in
            make.center.equalTo(self.snp.center)
            make.size.equalTo(self.snp.width).multipliedBy(0.6)
        }
    }
    
    private func setupSongLabel() {
        self.addSubview(currentSongLabel)
        currentSongLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(imageview.snp.bottom).offset(20)
        }
    }
    
    private func setupArtistLabel() {
        self.addSubview(currentArtistLabel)
        currentArtistLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(currentSongLabel.snp.bottom).offset(10)
        }
    }
    
    private func setupMediaControllerButtons() {
        let buttonStackView = UIStackView(arrangedSubviews: [rewindButton, playButton, nextButton])
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 30
        
        self.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(currentArtistLabel.snp.bottom).offset(30)
        }
    }
    
    private func setupVenueInfoButton() {
        self.addSubview(venueInfoButton)
        venueInfoButton.snp.makeConstraints { make in
            make.top.equalTo(playButton.snp.bottom).offset(20)
            make.centerX.equalTo(self.snp.centerX)
        }
    }
    
    private func setupLocalityLabel() {
        self.addSubview(locailityLabel)
        locailityLabel.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left).offset(20)
            make.bottom.equalTo(self.snp.bottom).offset(-20)
        }
    }
    
    private func setupRecordButton() {
        self.addSubview(recordButton)
        recordButton.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left).offset(20)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(-20)
        }
    }
    
    private func setupRecordingIndicator() {
        self.addSubview(recordingIndicator)
        recordingIndicator.snp.makeConstraints { make in
            make.left.equalTo(recordButton.snp.right).offset(20)
            make.top.equalTo(recordButton)
        }
    }
}
