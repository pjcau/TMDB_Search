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
import RxDataSources

class DetailMovieViewController: UIViewController, NibLoadable, BindableType {
    
    typealias ViewModelType = DetailMovieViewModelType
    typealias DetailMovieSectionModel = SectionModel<String, DetailMovieViewModelType>
    
    // MARK: ViewModel
    var viewModel: DetailMovieViewModelType!
    
    // MARK: IBOutlets
    @IBOutlet var detailTableView: UITableView!
    
    // MARK: Private
    private let disposeBag = DisposeBag()
    private var detailSourceMovies: RxTableViewSectionedReloadDataSource<DetailMovieSectionModel>!
    
    // MARK: Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAll()
    
    }
    
    // MARK: BindableType
    func bindViewModel() {
        let inputs = viewModel.inputs
        let outputs = viewModel.outputs
 
    }
    
    // MARK: UI
    private func configureAll() {
    }
    
    
}
