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
    var smallPhoto: Observable<String>! { get }
    var regularPhoto: Observable<String>! { get }
    var hightPhoto: Observable<String>! { get }
    var titlelabel: Observable<String>! { get }
    var dateRelease: Observable<String>! { get }
    var overviewText: Observable<String>! { get }
    var movie: Movie! { get }
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
    var smallPhoto: Observable<String>!
    var regularPhoto: Observable<String>!
    var hightPhoto: Observable<String>!
    var titlelabel: Observable<String>!
    var dateRelease: Observable<String>!
    var overviewText: Observable<String>!
    var movie: Movie!

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
        self.movie = movie
        movieStream = Observable.just(movie)

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
            .map { $0.release_date }
            .unwrap()

        overviewText = movieStream
            .map { $0.overview }
            .unwrap()

    }
}

enum FormatImage: String {
    case small = "w92",
    medium = "w185",
    large = "w500",
    extraLarge = "w780"
}

extension MovieViewModel {

    func getImage(_ pathImage: String?, format: FormatImage = .medium) -> String {
        return "https://image.tmdb.org/t/p/" + format.rawValue + (pathImage ?? "")
    }

}
