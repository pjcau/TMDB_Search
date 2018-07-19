//
//  Array+Utilities.swift
//  CareemAssignmentJonnyCau
//
//  Created by Pierre jonny cau on 17/07/2018.
//  Copyright © 2018 Pierre Jonny Cau. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    mutating func removeDuplicates() {
        var result = [Element]()
        for value in self {
            if !result.contains(value) {
                result.append(value)
            }
        }
        self = result
    }
}

extension Array {
    subscript (safe index: UInt) -> Element? {
        return Int(index) < count ? self[Int(index)] : nil
    }
}
