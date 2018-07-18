//
//  SceneTransitionType.swift
//  CareemAssignmentJonnyCau
//
//  Created by Pierre jonny cau on 11/07/2018.
//  Copyright © 2018 Pierre Jonny Cau. All rights reserved.
//


import UIKit

enum SceneTransitionType {
    
    case root(UIViewController)       // make view controller the root view controller.
    case push(UIViewController)       // push view controller to navigation stack.
    case present(UIViewController)    // present view controller.
    case alert(UIViewController)      // present alert.
    case tabBar(UITabBarController) 
}



