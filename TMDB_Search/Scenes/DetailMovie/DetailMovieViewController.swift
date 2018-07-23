//
//  DetailMovieViewController.swift
//  TMDB_Search
//
//  Created by Pierre jonny cau on 19/07/2018.
//  Copyright © 2018 Pierre Jonny Cau. All rights reserved.
//

import Foundation


import Foundation
import UIKit
import RxSwift
import Reusable
import Nuke

class DetailMovieViewController: UIViewController, NibLoadable, BindableType {
    
    typealias ViewModelType = DetailMovieViewModelType
    
    // MARK: ViewModel
    var viewModel: DetailMovieViewModelType!
    
    // MARK: IBOutlets
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var plotText: UITextView!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var originaltitleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    // MARK: Private
    private let disposeBag = DisposeBag()
    private static let imagePipeline = Nuke.ImagePipeline.shared

    // MARK: Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAll()
    
    }
    
    // MARK: BindableType
    func bindViewModel() {
        _ = viewModel.inputs
        let outputs = viewModel.outputs
        let this = DetailMovieViewController.self

        outputs.regularPhoto
            .mapToURL()
            .flatMap { this.imagePipeline.rx.loadImage(with: $0) }
            .map { $0.image }
            .bind(to: posterImage.rx.image)
            .disposed(by: disposeBag)
        
        outputs.titlelabel
            .bind(to: rx.title)
            .disposed(by: disposeBag)
        
        outputs.dateRelease
            .map { "Release:  \($0)"  }
            .bind(to: releaseDateLabel.rx.text)
            .disposed(by: disposeBag)
        
        outputs.overviewText
            .bind(to: plotText.rx.text)
            .disposed(by: disposeBag)
        
        outputs.originalTitle
            .map { "Original Title:  \($0)"  }
            .bind(to: originaltitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        outputs.voteAverage
            .map { "Vote average:  \($0)"  }
            .bind(to: voteAverageLabel.rx.text)
            .disposed(by: disposeBag)
        
        outputs.popularityText
            .map { "Popularity:  \($0)"  }
            .bind(to: popularityLabel.rx.text)
            .disposed(by: disposeBag)
      
    }
    
    // MARK: UI
    private func configureAll() {

    }

}
