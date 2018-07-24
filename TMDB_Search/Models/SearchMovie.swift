//
//  SearchMovie.swift
//  CareemAssignmentJonnyCau
//
//  Created by Pierre jonny cau on 11/07/2018.
//  Copyright © 2018 Pierre Jonny Cau. All rights reserved.
//

import Foundation

// MARK: SearchMovieResult

struct SearchMovie: Decodable {
    let page: Int?
    let total_results: Int?
    let total_pages: Int?
    let results: [Movie]?

    enum CodingKeys: String, CodingKey {

        case page = "page"
        case total_results = "total_results"
        case total_pages = "total_pages"
        case results = "results"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        page = try values.decodeIfPresent(Int.self, forKey: .page)
        total_results = try values.decodeIfPresent(Int.self, forKey: .total_results)
        total_pages = try values.decodeIfPresent(Int.self, forKey: .total_pages)
        results = try values.decodeIfPresent([Movie].self, forKey: .results)
    }

}
