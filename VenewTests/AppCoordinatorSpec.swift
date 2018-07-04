//
//  AppCoordinatorSpec.swift
//  DogWalkTests
//
//  Created by Masai Young on 5/11/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import XCTest
import Quick
import Nimble

@testable import Venew

class AppCoordinatorSpec: QuickSpec {
    override func spec() {
        describe("App Coordinator") {
            context("after being properly initialized") {
                let window = UIWindow()
                let coordinator: AppCoordinator = AppCoordinator(window: window)
                
                context("when you call start") {
                    beforeEach {
                        coordinator.childCoordinators.removeAll()
                    }
                    
                    context("calling start()") {
                        beforeEach {
                            coordinator.start()
                        }
                        it("should start nowPlaying flow") {
                            expect(coordinator.childCoordinators).toNot(beEmpty())
                            expect(coordinator.childCoordinators).to(containElementSatisfying({$0 is NowPlayingCoordinator}))
                        }
                    }
                
            }
        }
    }
}
}
