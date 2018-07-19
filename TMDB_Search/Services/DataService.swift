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
    
    private let bag = DisposeBag()
    
    lazy var config: Realm.Configuration = {
        var config = Realm.Configuration.defaultConfiguration
        return config
    }()
    
    private lazy var realm: Realm = {
        let realm: Realm
        do {
            realm = try Realm(configuration: self.config)
            return realm
        }
        catch let e {
            print(e)
            fatalError()
        }
    }()
    
    init() {
        setupRealm()
    }
    
    
    func addSuggestionQuery(_ string:String) {
        try! realm.write {
            guard let suggestion = realm.objects(Suggestion.self).first else   {
                return
            }
            let query = string.trimmingCharacters(in: NSCharacterSet.whitespaces)
            
            if !suggestion.queries.contains(where: {$0.text == query}) {
                createQuery(query)
            }
        }
    }
    
    private func setupRealm() {
        try! realm.write {
            guard realm.objects(Suggestion.self).first != nil else {
                realm.add(Suggestion())
                return
            }
        }
    }
    
    private func createQuery(_ string:String){
            guard let suggestion = realm.objects(Suggestion.self).first else   {
                return
            }
            let query = Query()
            query.text = string
            suggestion.queries.append(query)
    }


    
}
