//
//  MovieServiceSpec.swift
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
import Moya

@testable import TMDB_Search

class MovieServiceSpec: QuickSpec {

    override func spec() {

        var provider: MoyaProvider<Tmdb>!
        beforeEach {
            provider = MoyaProvider<Tmdb>(stubClosure: MoyaProvider.immediatelyStub)
        }

        describe("DataService") {
            it("returns stubbed data for search request") {
                var message: String?

                let target: Tmdb = .search(movieText: "jonny", perPage: 1)
                provider.request(target) { result in
                    if case let .success(response) = result {
                        message = String(data: response.data, encoding: .utf8)
                    }
                }

                let sampleData = target.sampleData
                expect(message) == String(data: sampleData, encoding: .utf8)
            }

            it("get array object from mock in RX") {

                let service = MovieService(tmdb: provider)
                let moviesObservbale = service.search(movieText: "jonny", byPageNumber: 1)
                        .flatMap { result -> Observable<[Movie]> in
                            switch result {
                            case let .success(movies):
                                if movies.count == 0 {
                                    return .empty()
                                }
                                return .just(movies)
                            case .error(_):
                                return .empty()
                            }
                    }

                do {
                    guard let result = try moviesObservbale.toBlocking().first() else {
                        fatalError()
                    }
                    expect(result.count) == 20
                    expect(result).to(beAnInstanceOf([Movie].self))
                    expect(result.first?.id) == 458_769

                } catch {
                    fatalError()
                }
            }

        }
    }
}
