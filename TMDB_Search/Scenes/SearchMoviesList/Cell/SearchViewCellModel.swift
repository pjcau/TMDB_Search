//
//  SearchViewCellModel.swift
//  CareemAssignmentJonnyCau
//
//  Created by Pierre jonny cau on 11/07/2018.
//  Copyright © 2018 Pierre Jonny Cau. All rights reserved.
//

import Foundation
import RxSwift
import Action

protocol SearchViewCellModelInput: MovieViewModelInput {
}

protocol SearchViewCellModelOutput: MovieViewModelOutput {

 }

protocol SearchViewCellModelType: MovieViewModelType {
    var inputs: SearchViewCellModelInput { get }
    var outputs: SearchViewCellModelOutput { get }
}

class SearchViewCellModel: MovieViewModel,
                            SearchViewCellModelType,
                            SearchViewCellModelInput,
                            SearchViewCellModelOutput {

    // MARK: Inputs & Outputs
    var inputs: SearchViewCellModelInput { return self }
    override var movieViewModelInputs: MovieViewModelInput { return inputs }

    var outputs: SearchViewCellModelOutput { return self }
    override var movieViewModelOutputs: MovieViewModelOutput { return outputs }

    // MARK: Output
    var moviePosterImage: Observable<String>!

    // MARK: Private

    // MARK: Init
    override init(
        movie: Movie,
        service: MovieServiceType = MovieService(),
        sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared
        ) {

        super.init(movie: movie, service: service)

        }
}
