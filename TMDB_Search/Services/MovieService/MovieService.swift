//
// MovieService.swift
//  CareemAssignmentJonnyCau
//
//  Created by Pierre jonny cau on 11/07/2018.
//  Copyright © 2018 Pierre Jonny Cau. All rights reserved.
//

import Foundation
import RxSwift
import Moya

struct MovieService: MovieServiceType {

    private var tmdb = MoyaProvider<Tmdb> (/* plugins: [NetworkLoggerPlugin(verbose: true)]*/)

    init(tmdb: MoyaProvider<Tmdb> = MoyaProvider<Tmdb>()) {
        self.tmdb = tmdb
    }

    func search(movieText: String, byPageNumber pageNumber: Int) -> Observable<Result<[Movie], String>> {
            return tmdb.rx
                .request(.search(
                    movieText: movieText,
                    perPage: pageNumber
                    )
                )
                .filterSuccessfulStatusCodes()
                .map(SearchMovie.self)
                .map { $0.results }
                .asObservable()
                .unwrap()
                .map(Result.success)
                .catchError { error in
                    return .just(.error(error.localizedDescription))
            }
    }

}
