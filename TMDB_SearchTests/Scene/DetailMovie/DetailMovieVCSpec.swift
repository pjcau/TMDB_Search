//
//  DetailMovieSpec.swift
//  TMDB_SearchTests
//
//  Created by Pierre jonny cau on 25/07/2018.
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

class DetailMovieVCSpec: QuickSpec {
    var sceneCoordinator: SceneCoordinator?
    var window = UIWindow()

    override func spec() {
        var detailVC: DetailMovieViewController!
        let mockMovie = Movie(vote_count:20, id:20, video:false, vote_average:20, title:"Jonny Movie", popularity:8.5, poster_path:"ola", original_language:"italian", original_title:"Bellisceddusu", genre_ids:[1, 2, 3], backdrop_path: "vai li", adult:true, overview:"i like very well. Watch thsi asap", release_date:"10/12/2015" )

        beforeEach {

            self.window.rootViewController = UIViewController()
            self.sceneCoordinator = SceneCoordinator(window: self.window)
            SceneCoordinator.shared = self.sceneCoordinator

            detailVC = DetailMovieViewController()
            detailVC.bind(to: DetailMovieViewModel(movie: mockMovie))

        }

        describe("DetailMovieVC") {
            it("A_init") {
                expect(detailVC).to(beAnInstanceOf(DetailMovieViewController.self))
            }

            it("B_Bind view model") {
                expect(detailVC.viewModel).to(beAnInstanceOf(DetailMovieViewModel.self))
            }

            it("C_Observable_originaltitle") {
                do {
                    guard let result = try detailVC.viewModel.outputs.originalTitle.toBlocking().first() else {
                        fatalError()
                    }
                    expect(result) == mockMovie.original_title

                } catch {
                    fatalError()
                }
            }

            it("D_Observable_voteAverage") {
                do {
                    guard let result = try detailVC.viewModel.outputs.voteAverage.toBlocking().first() else {
                        fatalError()
                    }
                    expect(result) == mockMovie.vote_average

                } catch {
                    fatalError()
                }
            }

            it("E_Observable_popularityText") {
                do {
                    guard let result = try detailVC.viewModel.outputs.popularityText.toBlocking().first() else {
                        fatalError()
                    }
                    expect(result) == mockMovie.popularity

                } catch {
                    fatalError()
                }
            }

            it("F_Observable_movieStream") {
                do {
                    guard let result = try detailVC.viewModel.outputs.movieStream.toBlocking().first() else {
                        fatalError()
                    }
                    expect(result) == mockMovie

                } catch {
                    fatalError()
                }
            }

            it("G_Observable_titlelabel") {
                do {
                    guard let result = try detailVC.viewModel.outputs.titlelabel.toBlocking().first() else {
                        fatalError()
                    }
                    expect(result) == mockMovie.title

                } catch {
                    fatalError()
                }
            }

            it("H_Observable_dateRelease") {
                do {
                    guard let result = try detailVC.viewModel.outputs.dateRelease.toBlocking().first() else {
                        fatalError()
                    }
                    expect(result) == mockMovie.release_date

                } catch {
                    fatalError()
                }
            }

            it("I_Observable_overviewText") {
                do {
                    guard let result = try detailVC.viewModel.outputs.overviewText.toBlocking().first() else {
                        fatalError()
                    }
                    expect(result) == mockMovie.overview

                } catch {
                    fatalError()
                }
            }

            it("L_Observable_smallPhoto") {
                do {
                    guard let result = try detailVC.viewModel.outputs.smallPhoto.toBlocking().first() else {
                        fatalError()
                    }
                    expect(result) == ImageUtils().getImage(mockMovie.poster_path, format: .small)

                } catch {
                    fatalError()
                }
            }

            it("M_Observable_regularPhoto") {
                do {
                    guard let result = try detailVC.viewModel.outputs.regularPhoto.toBlocking().first() else {
                        fatalError()
                    }
                    expect(result) == ImageUtils().getImage(mockMovie.poster_path, format: .medium)

                } catch {
                    fatalError()
                }
            }

            it("N_Observable_largePhoto") {
                do {
                    guard let result = try detailVC.viewModel.outputs.hightPhoto.toBlocking().first() else {
                        fatalError()
                    }
                    expect(result) == ImageUtils().getImage(mockMovie.poster_path, format: .large)

                } catch {
                    fatalError()
                }
            }
        }
    }
}
