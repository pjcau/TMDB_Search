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

protocol DetailMovieViewModelInput : MovieViewModelInput {
   
    
}

protocol DetailMovieViewModelOutput : MovieViewModelOutput{
    
    
}

protocol DetailMovieViewModelType : MovieViewModelType{
    var inputs: DetailMovieViewModelInput { get }
    var outputs: DetailMovieViewModelOutput { get }
}

class DetailMovieViewModel: MovieViewModel, DetailMovieViewModelType, DetailMovieViewModelInput, DetailMovieViewModelOutput{    
    
    // MARK: Inputs & Outputs
    var inputs: DetailMovieViewModelInput { return self }
    override var movieViewModelInputs: MovieViewModelInput { return inputs }
    
    var outputs: DetailMovieViewModelOutput { return self }
    override var movieViewModelOutputs: MovieViewModelOutput { return outputs }
    
    
    // MARK: Init
    override init(
        movie: Movie,
        service: MovieServiceType = MovieService(),
        sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared
        ) {
        
        super.init(movie: movie, service: service)
        
    }
}
