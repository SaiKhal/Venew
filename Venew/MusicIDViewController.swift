//
//  MusicIDViewController.swift
//  Venew
//
//  Created by Masai Young on 7/4/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class MusicIDViewController: UIViewController {
    
    let contentView = MusicIDView()
    let bag = DisposeBag()
    
    let viewModel: MusicIDViewModel
    
    func bindToViewModel() {
        // MARK: - Outputs
        viewModel.outputs.isRecording
            .drive(contentView.spinner.rx.isAnimating)
            .disposed(by: bag)
        
        viewModel.outputs.songName
            .drive(contentView.songNameLabel.rx.text)
            .disposed(by: bag)
        
        // MARK: - Inputs
        contentView.recordButton.rx.tap
            .bind { [weak self] in self?.viewModel.identifySong() }
            .disposed(by: bag)
    }
    
    init(with viewModel: MusicIDViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.addSubview(contentView)
        bindToViewModel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
    }
}
