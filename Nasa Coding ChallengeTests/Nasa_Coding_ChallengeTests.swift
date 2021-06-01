//
//  Nasa_Coding_ChallengeTests.swift
//  Nasa Coding ChallengeTests
//
//  Created by Idris Sop on 2021/05/08.
//

import XCTest
import RxSwift

@testable import Nasa_Coding_Challenge

class Nasa_Coding_ChallengeTests: XCTestCase {

    private var mockNasaAPIRepository = MockNasaAPIRepository()
    private var viewModelUnderTest: ListViewModel!
    private let disposeBag = DisposeBag()
    
    override func setUpWithError() throws {
        super.setUp()
        AsynchronousProvider.setAsyncRunner(DummyAsynchronousRunner())
        viewModelUnderTest = ListViewModel(repository: mockNasaAPIRepository)
    }

    override func tearDownWithError() throws {
        mockNasaAPIRepository.verify()
        AsynchronousProvider.reset()
        super.tearDown()
    }
    
    func testThatWhenFetchListIsCalledThenLoadingIndicatorObservableIsSetToTrue() {
        var loadingIndicatorArray = [Bool]()
        viewModelUnderTest.loadingIndicatorState.observe(on: MainScheduler.instance).subscribe(onNext: { showLoadingIndicator in
            loadingIndicatorArray.append(showLoadingIndicator)
            
        }).disposed(by: disposeBag)
        stubFetchCitiesSuccess()
        viewModelUnderTest.fetchList()
        XCTAssertTrue(loadingIndicatorArray[1])
    }
    
    func testThatWhenFetchListIsCalledAndIsSuccessfulThenRefreshContentViewObservableIsCalled() {
        var refreshContentViewState = false
        viewModelUnderTest.refreshContentViewState.observe(on: MainScheduler.instance).subscribe(onNext: {
            refreshContentViewState = true
        }).disposed(by: disposeBag)
        
        stubFetchCitiesSuccess()
        viewModelUnderTest.fetchList()
        XCTAssertTrue(refreshContentViewState)
    }
    
    func testThatWhenFetchListIsCalledAndIsSuccessfulThenLoadingIndicatorObservableIsSetToFalse() {
        var loadingIndicatorArray = [Bool]()
        viewModelUnderTest.loadingIndicatorState.observe(on: MainScheduler.instance).subscribe(onNext: { showLoadingIndicator in
            loadingIndicatorArray.append(showLoadingIndicator)
            
        }).disposed(by: disposeBag)
        stubFetchCitiesSuccess()
        viewModelUnderTest.fetchList()
        XCTAssertFalse(loadingIndicatorArray[2])
    }
    
    func testThatWhenFetchListIsCalledAndIsFailingThenLoadingIndicatorObservableIsSetToFalse() {
        var loadingIndicatorArray = [Bool]()
        viewModelUnderTest.loadingIndicatorState.observe(on: MainScheduler.instance).subscribe(onNext: { showLoadingIndicator in
            loadingIndicatorArray.append(showLoadingIndicator)
        }).disposed(by: disposeBag)
        
        stubFetchCitiesFailure()
        viewModelUnderTest.fetchList()
        XCTAssertFalse(loadingIndicatorArray[2])
    }
    
    func testThatWhenFetchListIsCalledAndIsFailingThenshowErrorObservableIsCalled() {
        var errorMessage = ""
        viewModelUnderTest.showErrorState.observe(on: MainScheduler.instance).subscribe(onNext: { message in
            errorMessage = message
        }).disposed(by: disposeBag)
        
        stubFetchCitiesFailure()
        viewModelUnderTest.fetchList()
        XCTAssertEqual("Failed to fetch", errorMessage)
    }
    
    func testThatWhenNumberOfNasaInListIsCalledWithFetchListCalledSuccessfulAndNotFilteredThenReturnNasaDataListCount() {
        let expectedNasaList = mockNasaData()
        stubFetchCitiesSuccess()
        viewModelUnderTest.fetchList()
        XCTAssertEqual(expectedNasaList.count, viewModelUnderTest.numberOfNasaInList())
    }
    
    func testThatWhenNumberOfNasaInListIsCalledWithFetchListCalledSuccessfulAndWithFilteredThenReturnFilteredNasaDataListCount() {
        stubFetchCitiesSuccess()
        viewModelUnderTest.fetchList()
        viewModelUnderTest.searchNasaWithKeyword(searchString: "keyword 1")
        XCTAssertEqual(2, viewModelUnderTest.numberOfNasaInList())
    }
    
    func testThatWhenNumberOfNasaInListIsCalledWithFetchListCalledSuccessfulAndWithFilteredThenReturnZeroCount() {
        stubFetchCitiesSuccess()
        viewModelUnderTest.fetchList()
        viewModelUnderTest.searchNasaWithKeyword(searchString: "keyword 5")
        XCTAssertEqual(0, viewModelUnderTest.numberOfNasaInList())
    }
    

    func testThatWhenDidSelectedNasaAtIndexIsCalledThennavigateToDetailsScreenObservableShouldBeCalled() {
        var nasa = NasaModel()
        let expectedNasa = mockNasaData()[1]
        viewModelUnderTest.navigateToDetailsScreenState.observe(on: MainScheduler.instance).subscribe(onNext: { nasaModel in
            nasa = nasaModel
        }).disposed(by: disposeBag)
        
        stubFetchCitiesSuccess()
        viewModelUnderTest.fetchList()
        
        viewModelUnderTest.didSelectedNasaAtIndex(index: 1)
        XCTAssertEqual(expectedNasa, nasa)
    }
    
    func testThatWhenSearchNasaWithKeywordIsCalledAndKeywordFoundThenHideNoRecordsFoundTextObservableShouldBeCalled() {
        var hideNoRecordsFoundTextState = false
        viewModelUnderTest.hideNoRecordsFoundTextState.observe(on: MainScheduler.instance).subscribe(onNext: {
            hideNoRecordsFoundTextState = true
        }).disposed(by: disposeBag)
        
        stubFetchCitiesSuccess()
        viewModelUnderTest.fetchList()
        viewModelUnderTest.searchNasaWithKeyword(searchString: "keyword 1")
        XCTAssertTrue(hideNoRecordsFoundTextState)
    }
    
    func testThatWhenSearchNasaWithKeywordIsCalledAndKeywordFoundThenShowNoRecordsFoundTextObservableShouldBeCalled() {
        var showNoRecordsFoundTextState = false
        viewModelUnderTest.showNoRecordsFoundTextState.observe(on: MainScheduler.instance).subscribe(onNext: {
            showNoRecordsFoundTextState = true
        }).disposed(by: disposeBag)
        
        stubFetchCitiesSuccess()
        viewModelUnderTest.fetchList()
        viewModelUnderTest.searchNasaWithKeyword(searchString: "keyword 5")
        XCTAssertTrue(showNoRecordsFoundTextState)
    }
    
    func stubFetchCitiesSuccess() {
        mockNasaAPIRepository.expectFetchNasaListForSuccess(nasaList: mockNasaData())
    }
    
    func stubFetchCitiesFailure() {
        mockNasaAPIRepository.expectFetchCitiesFailure(error: mockError())
    }
    
    func mockNasaData() -> [NasaModel] {
        return [NasaModel(imageLink: "link1", nasaId: "1", nasaDescription: "description1", dateCreated: "2021-06-01", title: "title1", photographer: "photographer1", keywords: ["keyword 1", "keyword 2"]),
                NasaModel(imageLink: "link2", nasaId: "2", nasaDescription: "description2", dateCreated: "2021-06-01", title: "title2", photographer: "photographer2", keywords: ["keyword 1", "keyword 3"]),
                NasaModel(imageLink: "link3", nasaId: "3", nasaDescription: "description3", dateCreated: "2021-06-01", title: "title3", photographer: "photographer3", keywords: ["keyword 4", "keyword 2"])]
    }
    
    func mockError() -> NSError {
        return NSError(domain: "Nasa", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch"])
    }
}
