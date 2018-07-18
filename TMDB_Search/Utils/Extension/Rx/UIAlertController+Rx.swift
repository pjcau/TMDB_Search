//
//  UIAlertController+Rx.swift
//  CareemAssignmentJonnyCau
//
//  Created by Pierre jonny cau on 11/07/2018.
//  Copyright © 2018 Pierre Jonny Cau. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UIAlertController {
    
    /// Bindable sink for `title`.
    public var title: Binder<String> {
        return Binder(base) { alertController, title in
            alertController.title = title
        }
    }
    
    /// Bindable sink for `message`.
    public var message: Binder<String> {
        return Binder(base) { alertController, message in
            alertController.message = message
        }
    }
}
