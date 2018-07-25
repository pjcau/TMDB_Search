//
//  SearchViewCell.swift
//  CareemAssignmentJonnyCau
//
//  Created by Pierre jonny cau on 11/07/2018.
//  Copyright © 2018 Pierre Jonny Cau. All rights reserved.
//

import UIKit
import RxSwift
import Nuke
import Hero
import Reusable

class SearchViewCell: UITableViewCell, BindableType, NibReusable {

    // MARK: ViewModel
    var viewModel: SearchViewCellModelType!

    // MARK: IBOutlets
    @IBOutlet var moviePosterImageView: UIImageView!
    @IBOutlet var movieTitleLabel: UILabel!
    @IBOutlet var releaseDateLabel: UILabel!
    @IBOutlet var fullOverviewLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    // MARK: Private
    private static let imagePipeline = Nuke.ImagePipeline.shared
    private var disposeBag = DisposeBag()
    private let radius: CGFloat = 10.0

    // MARK: Overrides

    override func awakeFromNib() {
        super.awakeFromNib()
        movieTitleLabel.layer.cornerRadius = radius
        movieTitleLabel?.layer.masksToBounds = true

        releaseDateLabel.layer.cornerRadius = radius
        releaseDateLabel?.layer.masksToBounds = true

        fullOverviewLabel.layer.cornerRadius = radius
        fullOverviewLabel?.layer.masksToBounds = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        movieTitleLabel.text = nil
        releaseDateLabel.text = nil
        fullOverviewLabel.text = nil
        moviePosterImageView.image = nil

        disposeBag = DisposeBag()
    }

    // MARK: BindableType

    func bindViewModel() {
       _ = viewModel.inputs
        let outputs = viewModel.outputs
        let this = SearchViewCell.self

        Observable.concat( outputs.regularPhoto, outputs.hightPhoto)
            .mapToURL()
            .flatMap { this.imagePipeline.rx.loadImage(with: $0) }
            .map { $0.image }
            .flatMapIgnore { [weak self] _ in
                Observable.just(self?.activityIndicator.stopAnimating())
            }
            .bind(to: moviePosterImageView.rx.image)
            .disposed(by: disposeBag)

        outputs.titlelabel
            .bind(to: movieTitleLabel.rx.text)
            .disposed(by: disposeBag)

        outputs.dateRelease
            .bind(to: releaseDateLabel.rx.text)
            .disposed(by: disposeBag)

        outputs.overviewText
            .bind(to: fullOverviewLabel.rx.text)
            .disposed(by: disposeBag)

    }

}
