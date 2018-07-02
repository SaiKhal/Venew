//
//  AppCoordinator.swift
//  DogWalk
//
//  Created by Masai Young on 5/11/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    
    init(rootNav navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        showNowPlaying()
    }
    
    private func showNowPlaying()  {
        let nowPlayingCoordinator = NowPlayingCoordinator(rootNav: navigationController)
        addChildCoordinator(nowPlayingCoordinator)
        nowPlayingCoordinator.start()
    }
    
}
