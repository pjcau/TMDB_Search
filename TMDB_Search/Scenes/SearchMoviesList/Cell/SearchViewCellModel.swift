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
    var titlelabel: Observable<String>! { get }
    var dateRelease: Observable<String>! { get }
    var overviewText: Observable<String>! { get }
    var smallPhoto: Observable<String>! { get }
    var regularPhoto: Observable<String>! { get }
    var hightPhoto: Observable<String>! { get }
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
    var smallPhoto: Observable<String>!
    var regularPhoto: Observable<String>!
    var hightPhoto: Observable<String>!
    var titlelabel: Observable<String>!
    var dateRelease: Observable<String>!
    var overviewText: Observable<String>!
 
    // MARK: Private
    
    // MARK: Init
    override init(
        movie: Movie,
        service: MovieServiceType = MovieService(),
        sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared
        ) {
        
        super.init(movie: movie, service: service)
    
        smallPhoto = movieStream
            .map { self.getImage($0.poster_path, format: .small) }
            .unwrap()
        
        regularPhoto = movieStream
            .map { self.getImage($0.poster_path, format: .medium) }
            .unwrap()
        
        hightPhoto = movieStream
            .map { self.getImage($0.poster_path, format: .large) }
            .unwrap()
        
        titlelabel = movieStream
            .map { $0.title }
            .unwrap()
        
        dateRelease = movieStream
            .map { $0.release_date   }
            .unwrap()
        
        overviewText = movieStream
            .map { $0.overview }
            .unwrap()
        }
}

enum FormatImage :String {
    case small = "w92",
    medium = "w185",
    large = "w500",
    extraLarge = "w780"
}

extension SearchViewCellModel{
    
    func getImage(_ pathImage:String?, format :FormatImage = .medium) -> String {
        return "https://image.tmdb.org/t/p/" + format.rawValue + (pathImage ?? "")
    }
    
}
