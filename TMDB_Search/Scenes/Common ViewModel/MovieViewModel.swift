//
//  MovieViewModel.swift
//  CareemAssignmentJonnyCau
//
//  Created by Pierre jonny cau on 12/07/2018.
//  Copyright © 2018 Pierre Jonny Cau. All rights reserved.
//

import Foundation
import RxSwift
import Action
import Photos

protocol MovieViewModelInput {
    //var alertAction: Action< String, String> { get }
 }

protocol MovieViewModelOutput {
    var movieStream: Observable<Movie>! { get }
}

protocol MovieViewModelType {
    var movieViewModelInputs: MovieViewModelInput { get }
    var movieViewModelOutputs: MovieViewModelOutput { get }
}

class MovieViewModel: MovieViewModelType,
                      MovieViewModelInput,
                      MovieViewModelOutput {
    
    // MARK: Inputs & Outputs
    var movieViewModelInputs: MovieViewModelInput { return self }
    var movieViewModelOutputs: MovieViewModelOutput { return self }
    
    // MARK: Input
    lazy var alertAction: Action<(title: String, message: String), Void> = {
        Action<(title: String, message: String), Void> { [unowned self] (title, message) in
            let alertViewModel = AlertViewModel(
                title: title,
                message: message,
                mode: .ok)
            return self.sceneCoordinator.transition(to: Scene.alert(alertViewModel))
        }
    }()
    
    
    // MARK: Output
    var movieStream: Observable<Movie>!
    
    let service: MovieServiceType
    let sceneCoordinator: SceneCoordinatorType
    
    // MARK: Private
    
    private let movieStreamProperty = BehaviorSubject<Movie?>(value: nil)
    
    // MARK: Init
    init(movie: Movie,
         service: MovieServiceType = MovieService(),
         sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {
        
        self.service = service
        self.sceneCoordinator = sceneCoordinator
        
        movieStream = Observable.just(movie)

    }
}
