//
//  DataService.swift
//  CareemAssignmentJonnyCau
//
//  Created by Pierre jonny cau on 17/07/2018.
//  Copyright © 2018 Pierre Jonny Cau. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

class DataService {

    // MARK: Variables

    private let bag = DisposeBag()
    let totalLastquery = 10
    lazy var config: Realm.Configuration = {
        var config = Realm.Configuration.defaultConfiguration
        return config
    }()

    private lazy var realm: Realm = {
        let realm: Realm
        do {
            realm = try Realm(configuration: self.config)
            return realm
        } catch let e {
            print(e)
            fatalError()
        }
    }()

    // MARK: Init

    init() {
        setupRealm()
    }

    // MARK: Public Methods

    func addSuggestionQuery(_ string: String) {
        try! realm.write {
            guard let suggestion = realm.objects(Suggestion.self).first else {
                return
            }
            let query = string.trimmingCharacters(in: NSCharacterSet.whitespaces)

            if !suggestion.queries.contains(where: { $0.text == query }) {
                if totalLastquery <= suggestion.queries.count {
                    deleteLastQuery()
                }
                createQuery(query)
            }
        }
    }

    func deleteDB() {
        try! realm.write {
            realm.deleteAll()
        }
    }

    func getSuggestionResult() -> Suggestion? {
        guard let suggestion = realm.objects(Suggestion.self).first else {
            return nil
        }
        return suggestion
    }

    // MARK: Privacte Methods

    private func setupRealm() {
        try! realm.write {
            guard realm.objects(Suggestion.self).first != nil else {
                realm.add(Suggestion())
                return
            }
        }
    }

    private func createQuery(_ string: String) {
            guard let suggestion = realm.objects(Suggestion.self).first else {
                return
            }
            let query = Query()
            query.text = string
            suggestion.queries.append(query)
    }

    private func deleteLastQuery() {
        guard let suggestion = realm.objects(Suggestion.self).first else {
            return
        }
        suggestion.queries.removeFirst()
    }

}
