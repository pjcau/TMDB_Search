//
//  Tmdb+SampleData.swift
//  TMDB_Search
//
//  Created by Pierre jonny cau on 24/07/2018.
//  Copyright © 2018 Pierre Jonny Cau. All rights reserved.
//

import UIKit

extension Tmdb {
    func getSearchData() -> Data? {
        guard  let url = Bundle.main.url(forResource: "search", withExtension: "json") else {
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            // Handle Error
            return nil
        }
    }
}
