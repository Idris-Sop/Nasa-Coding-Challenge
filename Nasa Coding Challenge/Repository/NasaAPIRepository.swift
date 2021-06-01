//
//  NasaAPIRepository.swift
//  Nasa Coding Challenge
//
//  Created by Idris Sop on 2021/05/10.
//

import UIKit


typealias RetrieveNasaListCompletionBlock = (_ success: [NasaModel]) -> Void
typealias CompletionFailureBlock = (_ error: NSError) -> Void

protocol NasaAPIRepository {

    func retrieveNasaList(with success: @escaping RetrieveNasaListCompletionBlock,
                          failure: @escaping CompletionFailureBlock)
}
