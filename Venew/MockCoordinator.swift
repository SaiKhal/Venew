//
//  AppCoordinator.swift
//  DogWalk
//
//  Created by Masai Young on 5/11/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import UIKit

final class MockCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    
    init(rootNav navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let nextCoordinator = MockCoordinator(rootNav: navigationController)
//        let stringForTesting = nextCoordinator.start()
        addChildCoordinator(nextCoordinator)
    }
}
