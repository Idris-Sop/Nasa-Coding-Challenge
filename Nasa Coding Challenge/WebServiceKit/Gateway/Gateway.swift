//
//  Gateway.swift
//  Nasa Coding Challenge
//
//  Created by Idris Sop on 2021/05/08.
//

import UIKit

typealias GatewayCompletionBlock = (_ success: NSData?, _ response: URLResponse?, _ error: NSError?) -> Void
typealias GatewayDownloadCompletionBlock = (_ success: URL?, _ response: URLResponse?, _ error: NSError?) -> Void

class Gateway: NSObject {
    
    private var session: URLSession?
    
    override init() {
        super.init()
        
        //MARK: Instantiate Session Configuration
        let sessionConfiguration = URLSessionConfiguration.default
        let operationQueue = OperationQueue.main
        sessionConfiguration.httpMaximumConnectionsPerHost = 5
        sessionConfiguration.requestCachePolicy = .useProtocolCachePolicy
        sessionConfiguration.timeoutIntervalForRequest = 100.0
        sessionConfiguration.timeoutIntervalForResource = 100.0
        
        self.session = URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: operationQueue)
    }
    
    //MARK: Execute HTTP Communication with Server
    func executeServerCommunicationWithURLRequest(with requestURL: URLRequest,
                                                  callBack: @escaping GatewayCompletionBlock) {
        let dataTask = session?.dataTask(with: requestURL) { (data, responseURL, error) in
            callBack(data as NSData?, responseURL, error as NSError?)
        }
        dataTask?.resume()
    }
    
    func executeServerDownloadCommunicationWithURLRequest(with requestURL: URL,
                                                          callBack: @escaping GatewayDownloadCompletionBlock) {
        let dataTask = session?.downloadTask(with: requestURL) { localURL, urlResponse, error in
            callBack(localURL as URL?, urlResponse, error as NSError?)
        }
        dataTask?.resume()
    }
}

extension Gateway: URLSessionDelegate {
    
}
