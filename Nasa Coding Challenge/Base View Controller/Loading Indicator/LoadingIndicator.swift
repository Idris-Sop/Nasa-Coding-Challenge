//
//  LoadingIndicator.swift
//  Nasa Coding Challenge
//
//  Created by Idris Sop on 2021/05/08.
//

import UIKit

class LoadingIndicator: UIView {

    // MARK: IBOutlet(s)
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var contentView: UIView!

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialiseView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialiseView()
    }
    

    private func initialiseView() {
        Bundle.main.loadNibNamed("LoadingIndicator",
                                 owner: self,
                                 options: nil)
        self.addSubview(contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    public func startLoadingIndicator() {
        self.activityIndicator.startAnimating()
    }
    
    public func stopLoadingIndicator() {
        self.activityIndicator.stopAnimating()
    }
}
