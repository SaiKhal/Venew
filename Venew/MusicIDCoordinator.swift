//
//  MusicIDCoordinator.swift
//  Venew
//
//  Created by Masai Young on 7/4/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import Foundation
import UIKit

final class MusicIDCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    
    let musicIdentifier: MusicIdentifier
    
    init(rootNav navigationController: UINavigationController, musicIDService: MusicIdentifier) {
        self.navigationController = navigationController
        self.musicIdentifier = musicIDService
    }
    
    func start() {
        let viewModel = MusicIDViewModel(musicIDService: musicIdentifier)
        let viewController = MusicIDViewController(with: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
}
