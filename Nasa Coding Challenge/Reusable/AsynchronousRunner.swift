//
//  AsynchronousRunner.swift
//  Nasa Coding Challenge
//
//  Created by Idris Sop on 2021/05/22.
//

import UIKit

protocol AsynchronousRunner {
    func runOnConcurrent(_ action: @escaping () -> Void, _ qos: DispatchQoS.QoSClass)
    func runOnMain(_ action: @escaping () -> Void)
}
