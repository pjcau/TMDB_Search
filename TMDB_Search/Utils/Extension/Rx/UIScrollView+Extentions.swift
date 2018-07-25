//
//  UIScrollView+Extentions.swift
//  CareemAssignmentJonnyCau
//
//  Created by Pierre jonny cau on 11/07/2018.
//  Copyright © 2018 Pierre Jonny Cau. All rights reserved.
//

import UIKit

extension UIScrollView {

    func isNearTheBottomEdge(offset: CGFloat = 100) -> Bool {
        return contentOffset.y + frame.size.height + offset >= contentSize.height
    }
}
