//
//  AsynchronousProvider.swift
//  Nasa Coding Challenge
//
//  Created by Idris Sop on 2021/05/22.
//

import UIKit

class AsynchronousProvider {

    private static var asyncRunner : AsynchronousRunner = AsynchronousRunnerImplementation()
    
    static func runOnConcurrent(_ action: @escaping () -> Void, _ qos: DispatchQoS.QoSClass) {
        asyncRunner.runOnConcurrent(action, qos)
    }
    
    static func runOnMain(_ action: @escaping () -> Void) {
        asyncRunner.runOnMain(action)
    }

    static func setAsyncRunner(_ asyncRunner: AsynchronousRunner) {
        self.asyncRunner = asyncRunner
    }
    
    static func reset() {
        asyncRunner = AsynchronousRunnerImplementation()
    }
}

