//
//  ImageUtils.swift
//  TMDB_Search
//
//  Created by Pierre jonny cau on 25/07/2018.
//  Copyright © 2018 Pierre Jonny Cau. All rights reserved.
//

import Foundation

enum FormatImage: String {
    case small = "w92",
    medium = "w185",
    large = "w500",
    extraLarge = "w780"
}

struct ImageUtils {

    func getImage(_ pathImage: String?, format: FormatImage = .medium) -> String {
        return "https://image.tmdb.org/t/p/" + format.rawValue + (pathImage ?? "")

    }

}
