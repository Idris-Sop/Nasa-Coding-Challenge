//
//  BaseViewController.swift
//  Nasa Coding Challenge
//
//  Created by Idris Sop on 2021/05/08.
//

import UIKit

class BaseViewController: UIViewController {

    @IBOutlet private var scrollView: UIScrollView?
    
    private let loadingIndicatorView = LoadingIndicator()

    @IBInspectable var screenTitle: String {
        get {
            return self.navigationItem.title ?? ""
        }
        set {
            self.navigationItem.title = newValue
        }
    }
    
    @IBInspectable var navigationBarRightButtonTitle: String? {
        didSet {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: self.navigationBarRightButtonTitle, style: .plain, target: self, action: #selector(rightNavigationBarButtonTapped))
        }
    }
    
    @IBInspectable var navigationBarLeftButtonTitle: String? {
        didSet {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: self.navigationBarLeftButtonTitle, style: .plain, target: self, action: #selector(leftNavigationBarButtonTapped))
            self.navigationItem.leftBarButtonItem?.tintColor = .black
        }
    }
    
    @IBInspectable var navigationBarRightButtonImage: UIImage? {
        didSet {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: navigationBarRightButtonImage, style: .plain, target: self, action: #selector(rightNavigationBarButtonImageTapped))
        }
    }
    
    @IBInspectable var navigationBarLeftButtonImage: UIImage? {
        didSet {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: self.navigationBarLeftButtonImage, style: .plain, target: self, action: #selector(leftNavigationBarButtonImageTapped))
        }
    }
    
    private func addSubViewAndBringToFront(view: UIView) {
        if let navigationController = self.navigationController,
           let frame = self.navigationController?.view.frame {
            navigationController.view.addSubview(view)
            view.frame = frame
            navigationController.view.bringSubviewToFront(view)
        } else {
            self.view.addSubview(view)
            view.frame = self.view.frame
            self.view.bringSubviewToFront(view)
        }
    }
    
    func showLoadingActivityIndicator() {
        self.addSubViewAndBringToFront(view: loadingIndicatorView)
        self.loadingIndicatorView.startLoadingIndicator()
    }
    
    func hideLoadingActivityIndicator() {
        self.loadingIndicatorView.removeFromSuperview()
        self.loadingIndicatorView.stopLoadingIndicator()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func rightNavigationBarButtonTapped() {
        //override in child
    }
    
    @objc func leftNavigationBarButtonTapped() {
        //override in child
    }
    
    @objc func rightNavigationBarButtonImageTapped() {
        //override in child
    }
    
    @objc func leftNavigationBarButtonImageTapped() {
        //override in child
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard () {
        view.endEditing(true)
    }
}
