//
//  ListViewModelDelegate.swift
//  Nasa Coding Challenge
//
//  Created by Idris Sop on 2021/05/10.
//

import UIKit

protocol ListViewModelDelegate: AnyObject {
    func showLoadingIndicator()
    func hideLoadingIndicator()  
    func refreshContentView()
    func showError(with message: String)
    func navigateToDetailsScreenWith(nasa: NasaModel)
}
