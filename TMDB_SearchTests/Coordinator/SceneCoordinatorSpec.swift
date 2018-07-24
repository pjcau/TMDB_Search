//
//  SceneCoordinatorSpec.swift
//  TMDB_SearchTests
//
//  Created by Pierre jonny cau on 24/07/2018.
//  Copyright © 2018 Pierre Jonny Cau. All rights reserved.
//

import XCTest
import Foundation
import Nimble
import Quick
import RealmSwift
import RxSwift
import RxBlocking

@testable import TMDB_Search

class SceneCoordinatorSpec: QuickSpec {

    var sceneCoordinator: SceneCoordinator?
    var window = UIWindow()

    override func spec() {
        describe("SceneCoordinator") {
            it("A_Init") {
                self.window.rootViewController = UIViewController()

                self.sceneCoordinator = SceneCoordinator(window: self.window)

                SceneCoordinator.shared = self.sceneCoordinator
                expect(self.sceneCoordinator).to(beAnInstanceOf(SceneCoordinator.self))
            }
        }
    }
}
