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

class NowPlayingViewController: UIViewController, UIPopoverControllerDelegate {
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
        
//        let media = viewModel.outputs.currentMediaItem
//            .map { $0.media }
        
        viewModel.outputs.currentMediaItem
            .map { $0.media }
            .map({$0.artist})
            .drive(contentView.currentArtistLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.outputs.currentMediaItem
            .map { $0.media }
            .map({$0.title})
            .drive(contentView.currentSongLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.outputs.currentMediaItem
            .map { $0.media }
            .map({ $0.artwork?.image(at: self.contentView.imageview.size) })
            .drive(contentView.imageview.rx.image)
            .disposed(by: bag)
        
        viewModel.outputs.areaName
            .drive(contentView.locailityLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.outputs.venueInfo
            .drive(contentView.venueInfoButton.rx.title())
            .disposed(by: bag)
        
        viewModel.outputs.playbackState
            .map { state -> UIImage in
                if state == "playing" {
                    return UIImage.init(named: "pauseIcon")!
                } else {
                    return UIImage.init(named: "playIcon")!
                }
            }
            .drive(contentView.playButton.rx.image())
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
//            .bind { [weak self] in self?.viewModel.inputs.identifySong() }
            .bind { [weak self] in self?.showVC() }
            .disposed(by: bag)
    }
    
    func showVC() {
        let vc = BlurredVC()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        navigationController?.present(vc, animated: false, completion: nil)
    }
    
}

extension NowPlayingViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return ModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

class ModalPresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return CGRect.zero }
        let width = containerView.bounds.width / 2
        let height = containerView.bounds.height / 2
        let x = containerView.frame.midX - (width / 2)
        let y = containerView.frame.midY - (height / 2)
        return containerView.frame
    }
}

extension UIView {
    var size: CGSize {
        return CGSize(width: self.bounds.width, height: self.bounds.height)
    }
}


