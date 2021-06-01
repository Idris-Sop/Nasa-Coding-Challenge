//
//  TestExpectable.swift
//  Nasa Coding ChallengeTests
//
//  Created by Idris Sop on 2021/06/01.
//

import UIKit

import XCTest

protocol TestExpectable {
    var expectedCount:Int {get}
    var identifier:String {get}
    var actualCount:Int {get set}
    var alreadyInvoked:Bool {get set}
    mutating func incrementCallCount()
    func validate() -> Bool
    var expectedResult:Any? {get}
}

extension TestExpectable {
    mutating func incrementCallCount() {
        actualCount += 1
    }
    
    func validate() -> Bool {
        return actualCount == expectedCount
    }
    
    mutating func expectationMethodInvoked() {
        alreadyInvoked = true
    }
}

extension Array where Element == TestExpectable {
    mutating func expectation(for identifier:String) -> TestExpectable? {
        guard let index = self.firstIndex(where: {$0.identifier == identifier && !($0.alreadyInvoked)}) else {
            fatalError("No expectation found for \(identifier)!")
        }
        self[index].incrementCallCount()
        self[index].expectationMethodInvoked()
        return self[index]
    }
    
    func verifyExpectation(for identifier: String, count: Int) {
        let actualCount = self.reduce(0) { previousCount, textExpectable in
            if(textExpectable.identifier == identifier) {
                return previousCount + textExpectable.actualCount
            } else {
                return previousCount
            }
        }
        XCTAssertEqual(count, actualCount)
    }
    
    func verify() {
        let failedExpectation = self.first(where: { !$0.validate()})
        XCTAssertNil(failedExpectation,"Expectation not met for \(failedExpectation!.identifier) with call count \(failedExpectation!.actualCount) instead of \(failedExpectation!.expectedCount)")
    }
}
