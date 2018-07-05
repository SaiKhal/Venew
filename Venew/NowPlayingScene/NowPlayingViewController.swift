//
//  NowPlayingViewController.swift
//  Venew
//
//  Created by Masai Young on 7/2/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional
import MediaPlayer

class NowPlayingViewController: UIViewController {
    let viewModel: NowPlayingViewModelType
    let contentView = NowPlayingView()
    let bag = DisposeBag()
    
    init(with nowPlayingViewModel: NowPlayingViewModelType) {
        viewModel = nowPlayingViewModel
        super.init(nibName: nil, bundle: nil)
        view.addSubview(contentView)
        bindToViewModel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func bindToViewModel() {
        /// Outputs
        viewModel.outputs.currentMediaItem
            .map({$0.artist})
            .drive(contentView.currentArtistLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.outputs.currentMediaItem
            .map({$0.title})
            .drive(contentView.currentSongLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.outputs.currentMediaItem
            .map({ $0.artwork?.image(at: self.contentView.imageview.size) })
            .drive(contentView.imageview.rx.image)
            .disposed(by: bag)
        
        viewModel.outputs.areaName
            .drive(contentView.locailityLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.outputs.playbackState
            .map { state -> String in
                if state == "playing" {
                    return "Pause"
                } else {
                    return "Play"
                }
            }
            .drive(contentView.playButton.rx.title())
            .disposed(by: bag)
        
        /// Inputs
        contentView.playButton.rx.tap
            .bind { [weak self] in self?.viewModel.inputs.play() }
            .disposed(by: bag)
        
        contentView.rewindButton.rx.tap
            .bind { [weak self] in self?.viewModel.inputs.rewind() }
            .disposed(by: bag)
        
        contentView.nextButton.rx.tap
            .bind { [weak self] in self?.viewModel.inputs.next() }
            .disposed(by: bag)
        
        contentView.recordButton.rx.tap
            .bind { [weak self] in self?.viewModel.inputs.identifySong() }
            .disposed(by: bag)
    }
}

extension UIView {
    var size: CGSize {
        return CGSize(width: self.bounds.width, height: self.bounds.height)
    }
}

