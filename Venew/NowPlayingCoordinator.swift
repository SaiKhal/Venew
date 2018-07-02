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
    
    init(rootNav navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        let viewModel = NowPlayingViewModel()
        nowPlayingViewController = NowPlayingViewController(with: viewModel)
    }
    
    func start() {
        navigationController.pushViewController(nowPlayingViewController, animated: true)
    }
    
}
