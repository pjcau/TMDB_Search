//
//  MovieServiceType.swift
//  CareemAssignmentJonnyCau
//
//  Created by Pierre jonny cau on 11/07/2018.
//  Copyright © 2018 Pierre Jonny Cau. All rights reserved.
//

import Foundation
import RxSwift

enum NonPublicScopeError {
    case error(withMessage: String)
}

protocol MovieServiceType {
    func search(movieText: String, byPageNumber pageNumber: Int) -> Observable<Result<[Movie], String>>
}
