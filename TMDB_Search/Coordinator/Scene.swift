//
//  Scene.swift
//  CareemAssignmentJonnyCau
//
//  Created by Pierre jonny cau on 11/07/2018.
//  Copyright © 2018 Pierre Jonny Cau. All rights reserved.
//

import UIKit
import Reusable
/**
     Refers to a screen managed by a view controller.
     It can be a regular screen, or a modal dialog.
     It comprises a view controller and a view model.
 */

protocol TargetScene {
    var transition: SceneTransitionType { get }
}

enum Scene {
    case app
    case movieDetails(DetailMovieViewModel)
    case alert(AlertViewModel)
    case mockApp
}

extension Scene: TargetScene {
    var transition: SceneTransitionType {
        switch self {
        case .app:

            // MARK: SearchViewController
            var mainVC = SearchViewController()
            let rootHomeVC = UINavigationController(rootViewController: mainVC)
            mainVC.bind(to: SearchViewModel())
            return .root(rootHomeVC)

        case let .movieDetails(viewModel):

            // MARK: DetailMovieViewController
            var detail = DetailMovieViewController()
            detail.bind(to: viewModel)
            return .push(detail)

        case let .alert(viewModel):

            // MARK: AlertViewController
            var vc = AlertViewController(title: nil, message: nil, preferredStyle: .alert)
            vc.bind(to: viewModel)
            return .alert(vc)

        case .mockApp:

            // MARK: mock App
            let mainVC = UIViewController()
            let rootHomeVC = UINavigationController(rootViewController: mainVC)
            return .root(rootHomeVC)
        }
    }
}
