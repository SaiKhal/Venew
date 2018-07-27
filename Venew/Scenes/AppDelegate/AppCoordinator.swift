//
//  AppCoordinator.swift
//  DogWalk
//
//  Created by Masai Young on 5/11/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import UIKit

final class AppCoordinator: Coordinator {
    // MARK: - Properties
    let window: UIWindow
    
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    
    // MARK: - Services
    let locationService = LocationService()
    let musicIDService = MusicIdentifier()
    let venueAPI: VenueAPIClient = VenueAPIClient()
    let mediaPlayer: MediaController = MediaPlayer()
    
    init(window: UIWindow) {
        let navController = UINavigationController()
        
        self.window = window
        window.rootViewController = navController
        
        navigationController = navController
    }
    
    public func start() {
        showNowPlaying()
    }
    
    private func showNowPlaying()  {
        let nowPlayingCoordinator = NowPlayingCoordinator(rootNav: navigationController,
                                                          locationService: locationService,
                                                          musicIDService: musicIDService,
                                                          venueAPIService: venueAPI,
                                                          mediaPlayer: mediaPlayer)
        addChildCoordinator(nowPlayingCoordinator)
        nowPlayingCoordinator.start()
    }
    
}
