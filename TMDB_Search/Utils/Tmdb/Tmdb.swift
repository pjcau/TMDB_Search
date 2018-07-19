//
//  Tmdb.swift
//  CareemAssignmentJonnyCau
//
//  Created by Pierre jonny cau on 11/07/2018.
//  Copyright © 2018 Pierre Jonny Cau. All rights reserved.
//

import Foundation
import Moya

enum Tmdb {
    //search movie
    case search(movieText: String?, perPage: Int?)
}

extension Tmdb: TargetType  {
    
    var baseHost :String {
        return "https://api.themoviedb.org/3"
    }
    
    var baseURL: URL {
    
        guard let url = URL(string: baseHost) else {
            fatalError("FAILED: \(baseHost)")
        }
        return url
    }
    
    var apiKey: String {
        return "2696829a81b1b5827d515ff121700838"
    }
    
    var path: String {
        switch self {
        case .search(_,_):
            return "/search/movie"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case  .search:
            return .get
        }
    }
    
    var task: Task {
      
        switch self {
        case .search(let movieText, let perPage):
            
            var params: [String: Any] = [:]
            params["api_key"] = self.apiKey
            params["query"] = movieText
            params["page"] = perPage
 
            return .requestParameters(
                parameters: params,
                encoding: URLEncoding.default)
        }
        
    }
 
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String : String]? {
        return ["Content-type":"application/json"]
    }
    
    var validationType: ValidationType {
        return .none
    }
}


public func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}
