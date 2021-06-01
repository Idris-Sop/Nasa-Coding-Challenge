//
//  MockNasaAPIRepository.swift
//  Nasa Coding ChallengeTests
//
//  Created by Idris Sop on 2021/06/01.
//

import UIKit

@testable import Nasa_Coding_Challenge

struct MockNasaAPIRepositoryExpectation: TestExpectable {
    var expectedCount: Int
    var identifier: String
    var actualCount = 0
    var alreadyInvoked = false
    var expectedResult: Any?
    
    init(count: Int, functionSignature: String) {
        self.identifier = functionSignature
        self.expectedCount = count
    }
}

class MockNasaAPIRepository: NSObject {
    
    private var stubResponseExpectation: [TestExpectable] = [TestExpectable]()
    private let fetchNasaListSignature = "fetchNasaListSignature"
    private var isFetchNasaListCallSucces = false
    private var nasaList = [NasaModel]()
    private var error: NSError!
    
    func verify() {
        self.stubResponseExpectation.verify()
    }
    
    func expectFetchNasaListForSuccess(nasaList: [NasaModel]) {
        isFetchNasaListCallSucces = true
        self.nasaList = nasaList
        stubResponseExpectation.append(MockNasaAPIRepositoryExpectation(count: 1, functionSignature: fetchNasaListSignature))
    }
    
    func expectFetchCitiesFailure(error: NSError) {
        isFetchNasaListCallSucces = false
        self.error = error
        stubResponseExpectation.append(MockNasaAPIRepositoryExpectation(count: 1, functionSignature: fetchNasaListSignature))
    }
}

extension MockNasaAPIRepository: NasaAPIRepository {
    
    func retrieveNasaList(with success: @escaping RetrieveNasaListCompletionBlock, failure: @escaping CompletionFailureBlock) {
        _ = stubResponseExpectation.expectation(for: fetchNasaListSignature)
        
        if isFetchNasaListCallSucces {
            success(self.nasaList)
        } else {
            failure(self.error)
        }
    }
}
