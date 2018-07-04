//
//  NowPlayingCoordinator.swift
//  Venew
//
//  Created by Masai Young on 7/2/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import Foundation
import UIKit

final class NowPlayingCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    
    var nowPlayingViewController: NowPlayingViewController
    
    let locationService: LocationService
    
    init(rootNav navigationController: UINavigationController, locationService: LocationService) {
        self.navigationController = navigationController
        self.locationService = locationService
        
        let viewModel = NowPlayingViewModel(locationService: locationService)
        nowPlayingViewController = NowPlayingViewController(with: viewModel)
    }
    
    func start() {
        navigationController.pushViewController(nowPlayingViewController, animated: true)
    }
    
}
