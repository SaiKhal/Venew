//
//  NowPlayingCoordinator.swift
//  Venew
//
//  Created by Masai Young on 7/2/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

final class NowPlayingCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    
    let locationService: LocationService
    let musicIDService: MusicIdentifier
    let bag = DisposeBag()
    
    init(rootNav navigationController: UINavigationController, locationService: LocationService, musicIDService: MusicIdentifier) {
        self.navigationController = navigationController
        self.locationService = locationService
        self.musicIDService = musicIDService
    }
    
    func start() {
        let viewModel = NowPlayingViewModel(locationService: locationService)
        let nowPlayingViewController = NowPlayingViewController(with: viewModel)
        navigationController.pushViewController(nowPlayingViewController, animated: true)
        
        viewModel.outputs.showMusicID
            .subscribe(onNext: { [weak self] in self?.goToMusicID() })
            .disposed(by: bag)
    }
    
    func goToMusicID() {
        let musicIDCoordinator = MusicIDCoordinator(rootNav: navigationController, musicIDService: musicIDService)
        addChildCoordinator(musicIDCoordinator)
        musicIDCoordinator.start()
    }
    
}
