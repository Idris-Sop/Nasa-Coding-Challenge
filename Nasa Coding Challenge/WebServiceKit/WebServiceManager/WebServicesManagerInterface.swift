//
//  WebServicesManagerInterface.swift
//  Nasa Coding Challenge
//
//  Created by Idris Sop on 2021/05/08.
//

import UIKit

typealias WebServiceManagerSuccessBlock = (_ data: NSData) -> Void
typealias WebServiceManagerFailureBlock = (_ error: NSError?) -> Void

protocol WebServicesManagerInterface {

    //MARK: Perform API Call Interface
    func performServerOperationWithURLRequest(stringURL: String,
                                              bodyRequestParameter: [String: Any]?,
                                              httpMethod: String,
                                              httpHeaderField: String?,
                                              success: @escaping (NSData?) -> (),
                                              failure: @escaping (NSError?) -> ())
}
