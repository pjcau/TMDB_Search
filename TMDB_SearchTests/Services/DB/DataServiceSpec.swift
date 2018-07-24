//
//  DataServiceSpec.swift
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

@testable import TMDB_Search

class DataServiceSpec: QuickSpec {

    var dataService: DataService!

    override func spec() {
        describe("DataService") {

            it("A_Init") {
                self.dataService = DataService()
                expect(self.dataService).to(beAnInstanceOf(DataService.self))
            }

            it("B_Clean") {
                self.dataService.deleteDB()
                let suggestion = self.dataService.getSuggestionResult()
                expect(suggestion).to(beNil())
            }

            it ("C_Write_Suggestion_on_DB") {
                self.dataService = DataService()
                guard let suggestion = self.dataService.getSuggestionResult() else {
                    fatalError()
                }
                if suggestion.isKind(of: Suggestion.self) {
                    expect(suggestion).notTo(beNil())
                }
            }

            it ("D_AddOneQuery") {
                let fakequery = "Fake1"
                self.dataService.addSuggestionQuery(fakequery)
                guard let query = self.dataService.getSuggestionResult()?.queries.first else {
                    fatalError()
                }
                expect(query.text) == fakequery
            }

            it ("D_AddSomeQuery") {
                let fakequeries = ["Fake2", "Fake3", "Fake4", "Fake5", "Fake6", "Fake7", "Fake8", "Fake9", "Fake10", "Fake11"]

                fakequeries.forEach({ query in
                    self.dataService.addSuggestionQuery(query)
                })

                guard let queriesDB = self.dataService.getSuggestionResult()?.queries else {
                    fatalError()
                }
                expect(queriesDB.count) == self.dataService.totalLastquery
            }
        }
    }

}
