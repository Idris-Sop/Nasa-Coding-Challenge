//
//  AsynchronousRunnerImplementation.swift
//  Nasa Coding Challenge
//
//  Created by Idris Sop on 2021/05/22.
//

import UIKit

class AsynchronousRunnerImplementation: NSObject, AsynchronousRunner {
    
    func runOnConcurrent(_ action: @escaping () -> Void, _ qos: DispatchQoS.QoSClass) {
        DispatchQueue.global(qos: qos).async(execute: action)
    }
    
    func runOnMain(_ action: @escaping () -> Void) {
        DispatchQueue.main.async(execute: action)
    }
}
