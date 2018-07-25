//
//  SearchListVCSpec.swift
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

class SearchListVCSpec: QuickSpec {

    var sceneCoordinator: SceneCoordinator?
    var window = UIWindow()

    override func spec() {
        var mainVC: SearchViewController!

        beforeEach {

            self.window.rootViewController = UIViewController()
            self.sceneCoordinator = SceneCoordinator(window: self.window)
            SceneCoordinator.shared = self.sceneCoordinator

            mainVC = SearchViewController()
            mainVC.bind(to: SearchViewModel())

        }

        describe("SearchListVC") {
            it("A_init") {
                expect(mainVC).to(beAnInstanceOf(SearchViewController.self))
            }

            it("B_Bind view model") {
                expect(mainVC.viewModel).to(beAnInstanceOf(SearchViewModel.self))
            }

            it("C_Observable_Searchtext") {

                mainVC.viewModel.inputs.searchString.onNext("ciao")

                do {
                    guard let result = try mainVC.viewModel.outputs.textQuery.toBlocking().first() else {
                        fatalError()
                    }
                    expect(result) == "ciao"

                } catch {
                    fatalError()
                }

            }

            it("D_Observable_Trigger_Done_Button") {

                mainVC.viewModel.inputs.triggerDone()

                do {
                    guard let result = try mainVC.viewModel.outputs.isDoneTap.toBlocking().first() else {
                        fatalError()
                    }
                    expect(result).to(beAnInstanceOf(Void.self))

                } catch {
                    fatalError()
                }

            }

        }
    }
}
