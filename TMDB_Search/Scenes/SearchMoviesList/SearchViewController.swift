//
//  SearchMoviesListViewController.swift
//  CareemAssignmentJonnyCau
//
//  Created by Pierre jonny cau on 11/07/2018.
//  Copyright © 2018 Pierre Jonny Cau. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxDataSources
import Reusable
import RxGesture
import JGProgressHUD
import RxRealm
import RxRealmDataSources

class SearchViewController: UIViewController, NibLoadable, BindableType {

    typealias ViewModelType = SearchViewModelType
    typealias SearchSectionModel = SectionModel<String, SearchViewCellModelType>

    // MARK: ViewModel
    var viewModel: SearchViewModelType!

    // MARK: IBOutlets
    @IBOutlet var dataTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var suggestionsTableView: UITableView!

    // MARK: Private
    private let disposeBag = DisposeBag()
    private var dataSourceMovies: RxTableViewSectionedReloadDataSource<SearchSectionModel>!
    private let placeholdTest = "Search Movie on TMDB"
    private var activityIndicator: JGProgressHUD!

    // MARK: Override
    override func viewDidLoad() {
        super.viewDidLoad()

        configureSearchBar()
        configureMoviesTableView()
        configureSuggestionsTableView()
        configureNavigationBar()
        configureActivityIndicator()
    }

    // MARK: BindableType
    func bindViewModel() {
        let inputs = viewModel.inputs
        let outputs = viewModel.outputs

        searchBar.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                self.showMoviesTable(false)
            })
            .disposed(by: disposeBag)

        searchBar.rx.searchButtonClicked
            .throttle(0.3, scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [unowned self] _ in
                self.searchQueryOnWeb()
            })
            .disposed(by: disposeBag)

        searchBar.rx.text
            .filter { ($0 ?? "").count > 0 }
            .bind(to: inputs.searchString)
            .disposed(by: disposeBag)

        outputs.movies.subscribe { (_) in
                self.showMoviesTable(true)
                self.activityIndicator.dismiss(afterDelay: 0.0)
            }
            .disposed(by: disposeBag)

        outputs.searchViewCellModelTypes
            .map { [SearchSectionModel(model: "", items: $0)] }
            .bind(to: dataTableView.rx.items(dataSource: dataSourceMovies))
            .disposed(by: disposeBag)

        dataTableView.rx
            .contentOffset
            .flatMap { [unowned self] _ in
                return Observable.just(self.dataTableView.isNearTheBottomEdge())
            }
            .distinctUntilChanged()
            .bind(to: inputs.loadMore)
            .disposed(by: disposeBag)

        dataTableView.rx.modelSelected(SearchViewCellModel.self)
            .subscribe(onNext: { model in
                inputs.movieDetailsAction.execute(model.outputs.movie)
            })
            .disposed(by: disposeBag)

        dataTableView.rx
            .itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.dataTableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)

        // Create Suggestion Table
        let suggestionsDataSource = RxTableViewRealmDataSource<Query>(cellIdentifier: "QueryCell", cellType: QueryCell.self) {cell, _, query in
            cell.customLabel.text = "\(query.text)"
        }

        // bind to table view
        outputs.queryResults
            .bind(to: suggestionsTableView.rx.realmChanges(suggestionsDataSource))
            .disposed(by: disposeBag)

        // react on cell taps
        suggestionsTableView.rx.realmModelSelected(Query.self)
            .map({ $0.text })
            .asObservable()
            .subscribe({  query in
                guard let query = query.element else {
                    return
                }

                self.updateSearchBar(query)
                self.searchQueryOnWeb()
            })
            .disposed(by: disposeBag)

    }

    // MARK: UI

    private func updateSearchBar( _ query: String) {
        let inputs = viewModel.inputs

        self.searchBar.text = query
        inputs.searchString.onNext(query)
    }

    private func searchQueryOnWeb() {
        viewModel.inputs.triggerDone()
        self.dataTableView.setContentOffset(.zero, animated: false)
        self.view.endEditing(true)
        self.activityIndicator.show(in: self.dataTableView)
    }

    private func showMoviesTable( _ show: Bool) {
        dataTableView.isHidden = !show
        suggestionsTableView.isHidden = show
    }

    private func configureNavigationBar() {
        self.title = "Search Movie"
    }

    private func configureSearchBar() {
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = placeholdTest
    }

    private func configureSuggestionsTableView() {
        dataTableView.register(cellType: SearchViewCell.self)
        dataTableView.estimatedRowHeight = 400
        dataTableView.tableFooterView = UIView()
        dataTableView.setContentOffset(.zero, animated: true)
    }

    private func configureMoviesTableView() {
        suggestionsTableView.register(cellType: QueryCell.self)
        //suggestionsTableView.estimatedRowHeight = 450
        //suggestionsTableView.tableFooterView = UIView()
        suggestionsTableView.setContentOffset(.zero, animated: false)

        dataSourceMovies = RxTableViewSectionedReloadDataSource<SearchSectionModel>(
            configureCell:  tableViewDataSource
        )
    }

    private func configureActivityIndicator() {
        activityIndicator = JGProgressHUD(style: .dark)
        activityIndicator.textLabel.text = "Loading"
    }

    private var tableViewDataSource: TableViewSectionedDataSource<SearchSectionModel>.ConfigureCell {
        return { _, tableView, indexPath, cellModel in
            var cell = tableView.dequeueReusableCell(for: indexPath, cellType: SearchViewCell.self)
            cell.bind(to: cellModel)

            return cell
        }
    }
}
