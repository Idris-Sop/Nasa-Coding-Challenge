//
//  ListViewModel.swift
//  Nasa Coding Challenge
//
//  Created by Idris Sop on 2021/05/10.
//

import UIKit
import RxSwift

class ListViewModel {

    private var repository: NasaAPIRepository?
    private var nasaList = [NasaModel]()
    private var filteredNasaList = [NasaModel]()
    
    private let disposeBag = DisposeBag()
    
    private let loadingIndicator = BehaviorSubject<Bool>(value: false)
    public var loadingIndicatorState: Observable<Bool> {
        return loadingIndicator.asObservable()
    }
    
    private let refreshContentView = PublishSubject<Void>()
    public var refreshContentViewState: Observable<Void> {
        return refreshContentView.asObservable()
    }
    
    private let showError = PublishSubject<String>()
    public var showErrorState: Observable<String> {
        return showError.asObservable()
    }
    
    private let navigateToDetailsScreen = PublishSubject<NasaModel>()
    public var navigateToDetailsScreenState: Observable<NasaModel> {
        return navigateToDetailsScreen.asObservable()
    }
    
    private let hideNoRecordsFoundText = PublishSubject<Void>()
    public var hideNoRecordsFoundTextState: Observable<Void> {
        return hideNoRecordsFoundText.asObservable()
    }
    
    private let showNoRecordsFoundText = PublishSubject<Void>()
    public var showNoRecordsFoundTextState: Observable<Void> {
        return showNoRecordsFoundText.asObservable()
    }
    
    init(repository: NasaAPIRepository = NasaAPIRepositoryImplementation()) {
        self.repository = repository
    }
    
    func fetchList() {
        loadingIndicator.onNext(true)
        AsynchronousProvider.runOnConcurrent({
            self.repository?.retrieveNasaList(with: { [weak self](nasaList) in
                AsynchronousProvider.runOnMain {
                    self?.nasaList = nasaList
                    self?.filteredNasaList = nasaList
                    self?.refreshContentView.onNext(Void())
                    self?.loadingIndicator.onNext(false)
                }
            }, failure: { [weak self](error) in
                AsynchronousProvider.runOnMain {
                    self?.loadingIndicator.onNext(false)
                    self?.showError.onNext(error.localizedDescription)
                }
            })
        }, .userInitiated)
    }
    
    func numberOfNasaInList() -> Int {
        return self.filteredNasaList.count
    }
    
    func nasaAtIndex(index: Int) -> NasaModel {
        return self.filteredNasaList[index]
    }
    
    func didSelectedNasaAtIndex(index: Int) {
        self.navigateToDetailsScreen.onNext(self.filteredNasaList[index])
    }
    
    func searchNasaWithKeyword(searchString: String) {
        self.filteredNasaList = [NasaModel]()
        let nasaArray = self.nasaList
        
        AsynchronousProvider.runOnConcurrent ({
            if searchString.isEmpty {
                self.filteredNasaList = nasaArray
            } else {
                self.filteredNasaList = nasaArray.filter { $0.keywords?.contains(where: { $0.ignoreCaseContains(searchString) }) ?? false }
            }
            AsynchronousProvider.runOnMain {
                self.handleDisplayOfNoRecordsFoundText()
                self.refreshContentView.onNext(Void())
            }
        }, .userInteractive)
    }
    
    private func handleDisplayOfNoRecordsFoundText() {
        let nasaListToDisplay = numberOfNasaInList() > 0
        if (nasaListToDisplay) {
            self.hideNoRecordsFoundText.onNext(Void())
        } else {
            self.showNoRecordsFoundText.onNext(Void())
        }
    }
}

extension String {
    func ignoreCaseContains(_ searchable: String) -> Bool {
        return self.lowercased().contains(searchable.lowercased())
    }
}
