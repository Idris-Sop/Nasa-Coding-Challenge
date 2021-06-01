//
//  DetailsViewController.swift
//  Nasa Coding Challenge
//
//  Created by Idris Sop on 2021/05/08.
//

import UIKit
import RxSwift

class DetailsViewController: BaseViewController {

    @IBOutlet private var headerImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var authorLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var nasaDescriptionLabel: UILabel!
    
    private var selectedNasa: NasaModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.headerImageView.setImageWith(urlString: selectedNasa?.imageLink ?? "")
        self.titleLabel?.text = selectedNasa?.title
        self.authorLabel?.text = selectedNasa?.photographer
        self.dateLabel?.text = selectedNasa?.dateCreated
        self.nasaDescriptionLabel.text = selectedNasa?.nasaDescription
    }
    
    func setupViewWith(nasaModel: NasaModel) {
        self.selectedNasa = nasaModel
    }
}
