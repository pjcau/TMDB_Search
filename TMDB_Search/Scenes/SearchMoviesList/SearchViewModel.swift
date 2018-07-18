//
//  SearchMoviesListViewModel.swift
//  CareemAssignmentJonnyCau
//
//  Created by Pierre jonny cau on 11/07/2018.
//  Copyright © 2018 Pierre Jonny Cau. All rights reserved.
//

import Foundation
import RxSwift
import Action
import RxSwiftExt
import RxViewModel
import RealmSwift
import RxDataSources
import RxRealm

protocol SearchViewModelInput {
    /// Call when the bottom of the list is reached
    var loadMore: BehaviorSubject<Bool> { get }
    
    /// Call when an alert is invoked
    var alertAction: Action<String, Void> { get }
    
    // call when write
    var searchString: BehaviorSubject<String?> { get }
    
    // trigger the search bar
    func triggerDone()
    
}

protocol SearchViewModelOutput {
    /// Emits an array of photos for the collectionView
    var movies: Observable<[Movie]>! { get }

    /// Emites the child viewModels
    var searchViewCellModelTypes: Observable<[SearchViewCellModelType]> { get }
    
    var isDoneTap: Observable<Void>! { get }
    
    var textQuery: Observable<String?>! { get }
    
    var queryResults: Observable<(AnyRealmCollection<Query>, RealmChangeset?)>! { get }

}

protocol SearchViewModelType {
    var inputs: SearchViewModelInput { get }
    var outputs: SearchViewModelOutput { get }
}

class SearchViewModel: SearchViewModelType, SearchViewModelInput, SearchViewModelOutput{
   
    // MARK: Inputs & Outputs
    var inputs: SearchViewModelInput { return self }
    var outputs: SearchViewModelOutput { return self }
    
    // MARK: Input
    var loadMore = BehaviorSubject<Bool>(value: false)
    var searchString = BehaviorSubject<String?>(value: nil)


    lazy var alertAction: Action<String, Void> = {
        Action<String, Void> { [unowned self] message in
            let alertViewModel = AlertViewModel(
                title: "Upsss...",
                message: message,
                mode: .ok)
            return self.sceneCoordinator.transition(to: Scene.alert(alertViewModel))
        }
    }()
    
    func triggerDone()  {
        searchTrigger.onNext(())
    }
   
    // MARK: Output
    var movies: Observable<[Movie]>!
    var isDoneTap: Observable<Void>!
    var textQuery: Observable<String?>!
    var queryResults: Observable<(AnyRealmCollection<Query>, RealmChangeset?)>!
 
    lazy var searchViewCellModelTypes: Observable<[SearchViewCellModelType]> = {
        return movies.mapMany { SearchViewCellModel(movie: $0) }
    }()
    
    // MARK: Private
    private let service: MovieServiceType
    private let sceneCoordinator: SceneCoordinatorType
    private let searchTrigger = BehaviorSubject<Void>(value: ())

    // MARK: Init
    init(service: MovieServiceType = MovieService(), sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {
        self.sceneCoordinator = sceneCoordinator
        self.service = service
        let dataService = DataService()
        
        // RxRealm to get Observable<Results>
        let realm = try! Realm(configuration: dataService.config)
        queryResults = Observable.changeset(from: realm.objects(Suggestion.self).first!.queries.sorted(byKeyPath: "createdAt", ascending:false))
            .share()
        
        var currentPageNumber = 1
        var moviesArray = [Movie]([])
        
        isDoneTap = searchTrigger.asObservable()
        textQuery = searchString.asObservable()
        
        
        let requestFirst =  isDoneTap
            .flatMap { ( _)  -> Observable<[Movie]> in
                guard let query = try! self.searchString.value() else { return .empty() }
                
                return service.search(
                    movieText:query,
                    byPageNumber: 1)
                    .flatMap { [unowned self] result -> Observable<[Movie]> in
                        switch result {
                        case let .success(movies):
                            if movies.count == 0{
                                guard let query = try! self.searchString.value() else {return .empty()}
                                self.alertAction.execute("NO movies found with this query: \(query))")
                                return .empty()
                            }
                            dataService.addSuggestionQuery(query)
                            return .just(movies)
                        case let .error(error):
                            self.alertAction.execute(error)
                            return .empty()
                        }
                }
            }
            .do (onNext: { _ in
                moviesArray = []
                currentPageNumber = 1
            })
        



        let requestNext =  loadMore
            .flatMap { (loadMore)  -> Observable<[Movie]> in
                guard let query = try! self.searchString.value() else { return .empty() }
               
                currentPageNumber += 1
                return service.search(
                    movieText:query,
                    byPageNumber: currentPageNumber)
                    .flatMap { [unowned self] result -> Observable<[Movie]> in
                        switch result {
                        case let .success(movies):
                            return .just(movies)
                        case let .error(error):
                            self.alertAction.execute(error)
                            return .empty()
                        }
                }
        }

        movies = requestFirst
            .merge(with: requestNext)
            .map {  movies -> [Movie] in
                movies.forEach { movie in
                    moviesArray.append(movie)
                }
                return moviesArray
        }
        
    }
}
