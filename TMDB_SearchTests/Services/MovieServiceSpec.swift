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

        }
    }

}
