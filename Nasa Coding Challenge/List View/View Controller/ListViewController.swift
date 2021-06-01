//
//  ListViewController.swift
//  Nasa Coding Challenge
//
//  Created by Idris Sop on 2021/05/08.
//

import UIKit
import RxSwift

class ListViewController: BaseViewController {

    private let disposeBag = DisposeBag()
    
    @IBOutlet private var nasaSearchBar: UISearchBar! {
        didSet {
            nasaSearchBar.delegate = self
        }
    }
    
    @IBOutlet private var noRecordFoundLabel: UILabel!
    
    @IBOutlet var listTableView: UITableView! {
        didSet {
            listTableView.rowHeight = UITableView.automaticDimension
            listTableView.estimatedRowHeight = UITableView.automaticDimension
            listTableView.tableFooterView = UIView(frame: .zero)
        }
    }
    
    private var selectedNasa: NasaModel?
    
    // MARK: Dependencies
    private lazy var viewModel = ListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.noRecordFoundLabel.isHidden = true
        hideKeyboardWhenTappedAround()
        subscribeToViewModelObservables()
        viewModel.fetchList()
    }
    
    private func subscribeToViewModelObservables() {
        viewModel.loadingIndicatorState.observe(on: MainScheduler.instance).subscribe(onNext: { showLoadingIndicator in
            if showLoadingIndicator {
                self.showLoadingActivityIndicator()
            } else {
                self.hideLoadingActivityIndicator()
            }
        }).disposed(by: disposeBag)

        viewModel.refreshContentViewState.observe(on: MainScheduler.instance).subscribe(onNext: {
            self.listTableView.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.showErrorState.observe(on: MainScheduler.instance).subscribe(onNext: { errorMessage in
            let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Retry", style: .cancel, handler: nil))
            self.present(alertController, animated: true) {
                self.viewModel.fetchList()
            }
        }).disposed(by: disposeBag)
        
        viewModel.navigateToDetailsScreenState.observe(on: MainScheduler.instance).subscribe(onNext: { nasaModel in
            self.selectedNasa = nasaModel
            self.performSegue(withIdentifier: "detailsSegueIdentifier", sender: self)
        }).disposed(by: disposeBag)
        
        viewModel.hideNoRecordsFoundTextState.observe(on: MainScheduler.instance).subscribe(onNext: {
            self.noRecordFoundLabel.isHidden = true
            self.listTableView.isHidden = false
        }).disposed(by: disposeBag)
        
        viewModel.showNoRecordsFoundTextState.observe(on: MainScheduler.instance).subscribe(onNext: {
            self.noRecordFoundLabel.isHidden = false
            self.listTableView.isHidden = true
        }).disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsSegueIdentifier" {
            let detailsViewController = segue.destination as? DetailsViewController
            guard let nasa = selectedNasa else {
                return
            }
            detailsViewController?.setupViewWith(nasaModel: nasa)
        }
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfNasaInList()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = tableView.dequeueReusableCell(withIdentifier: "NasaCell", for: indexPath) as? ListTableViewCell
        let currentNasa = viewModel.nasaAtIndex(index: indexPath.row)

        customCell?.populateCellith(title: currentNasa.title ?? "", author: currentNasa.photographer ?? "", dateCreated: currentNasa.dateCreated ?? "", imageLink: currentNasa.imageLink ?? "")
        customCell?.accessoryType = .disclosureIndicator
        return customCell ?? ListTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectedNasaAtIndex(index: indexPath.row)
    }
}

// MARK: UISearchBarDelegate

extension ListViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchNasaWithKeyword(searchString: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
