//
//  DetailMovieViewModel.swift
//  TMDB_Search
//
//  Created by Pierre jonny cau on 19/07/2018.
//  Copyright © 2018 Pierre Jonny Cau. All rights reserved.
//

import Foundation
import RxSwift
import Action
import RxSwiftExt

protocol DetailMovieViewModelInput: MovieViewModelInput {

}

protocol DetailMovieViewModelOutput: MovieViewModelOutput {
    var originalTitle: Observable<String>! { get }
    var voteAverage: Observable<Double>! { get }
    var popularityText: Observable<Double>! { get }

}

protocol DetailMovieViewModelType: MovieViewModelType {
    var inputs: DetailMovieViewModelInput { get }
    var outputs: DetailMovieViewModelOutput { get }
}

class DetailMovieViewModel: MovieViewModel, DetailMovieViewModelType, DetailMovieViewModelInput, DetailMovieViewModelOutput {

    // MARK: Inputs 
    var inputs: DetailMovieViewModelInput { return self }
    override var movieViewModelInputs: MovieViewModelInput { return inputs }

    // MARK: Output
    var outputs: DetailMovieViewModelOutput { return self }
    override var movieViewModelOutputs: MovieViewModelOutput { return outputs }

    var originalTitle: Observable<String>!
    var voteAverage: Observable<Double>!
    var popularityText: Observable<Double>!

    // MARK: Init
    override init(
        movie: Movie,
        service: MovieServiceType = MovieService(),
        sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared
        ) {

        super.init(movie: movie, service: service)

        originalTitle = movieStream
            .map { $0.original_title }
            .unwrap()

        voteAverage = movieStream
            .map { $0.vote_average }
            .unwrap()

        popularityText = movieStream
            .map { $0.popularity }
            .unwrap()

    }
}
