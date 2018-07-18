//
//  Suggestion.swift
//  CareemAssignmentJonnyCau
//
//  Created by Pierre jonny cau on 17/07/2018.
//  Copyright © 2018 Pierre Jonny Cau. All rights reserved.
//

import Foundation
import RealmSwift

class Suggestion: Object {
    let queries = List<Query>()
}
