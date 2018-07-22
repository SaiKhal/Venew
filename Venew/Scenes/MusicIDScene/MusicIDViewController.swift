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
        
        viewModel.outputs.songArtist
            .drive(contentView.songArtistLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.outputs.volume
            .drive(onNext: { volume in
//                print(volume)
            }).disposed(by: bag)
        
        let timer = Observable<Int>
            .interval(0.009, scheduler: MainScheduler.instance)
        
        Observable
            .combineLatest(viewModel.outputs.volume.asObservable().map { CGFloat($0 * 6) },
                           timer,
                           resultSelector: { change, _ in change })
//            .debug()
            //.scan(1) { (last, change) in return last == 1 ? -change : -last }
            //.debug()
            .subscribe(onNext: { change in
                self.updateWaveform(change: change)
            }).disposed(by: bag)
        
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
    
    deinit {
        viewModel.viewDidDisappear()
        print("LEAVING")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.viewDidAppear()
    }
    
    func updateWaveform(change: CGFloat) {
        self.contentView.audioWaveform.amplitude = change / 5
    }
}
