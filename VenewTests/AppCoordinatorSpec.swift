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
                let navController = UINavigationController()
                let mockDependency = MockDependency()
                let coordinator: AppCoordinator = AppCoordinator(rootNav: navController, dependency: mockDependency)
                
                it("should have all initial services") {
                    expect(coordinator.dependencies).toNot(beNil())
                }
                
                it("should know if the user is logged in") {
                    expect(coordinator.isLoggedIn).to(beTrue())
                }
                
                context("when you call start") {
                    beforeEach {
                        coordinator.childCoordinators.removeAll()
                    }
                    
                    context("if logged in") {
                        beforeEach {
                            coordinator.isLoggedIn = true
                            coordinator.start()
                        }
                        it("should start map flow") {
                            expect(coordinator.childCoordinators).toNot(beEmpty())
                            expect(coordinator.childCoordinators).to(containElementSatisfying({ (coord) -> Bool in
                                return coord is MapVCCoordinator
                            }))
                        }
                    }
                    
                    context("if not logged in") {
                        beforeEach {
                            coordinator.isLoggedIn = false
                            coordinator.start()
                        }
                        it("should start authentification flow") {
                            expect(coordinator.childCoordinators).toNot(beEmpty())
                            expect(coordinator.childCoordinators).to(containElementSatisfying({ (coord) -> Bool in
                                return coord is AuthCoordinator
                            }))
                        }
                    }
                }
                
            }
        }
    }
}
