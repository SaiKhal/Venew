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

class MusicIDView: UIView {
    
    lazy var songNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Look For Songs"
        return label
    }()
    
    lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.backgroundColor = .blue
        return spinner
    }()
    
    lazy var recordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Record", for: .normal)
        button.backgroundColor = .red
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func setup() {
        self.backgroundColor = .white
        setupNameLabel()
        setupRecordButton()
        setupSpinner()
    }
    
    func setupNameLabel() {
        self.addSubview(songNameLabel)
        songNameLabel.snp.makeConstraints { make in
            make.center.equalTo(self.snp.center)
        }
    }
    
    func setupRecordButton() {
        self.addSubview(recordButton)
        recordButton.snp.makeConstraints { make in
            make.top.equalTo(songNameLabel.snp.bottom).offset(20)
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
}
