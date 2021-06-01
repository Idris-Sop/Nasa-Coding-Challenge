//
//  ListTableViewCell.swift
//  Nasa Coding Challenge
//
//  Created by Idris Sop on 2021/05/10.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet private var nasaImageView: UIImageView?
    @IBOutlet private var titleLabel: UILabel?
    @IBOutlet private var authorLabel: UILabel?
    @IBOutlet private var dateLabel: UILabel?
    @IBOutlet private var imageViewLoadingIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func populateCellith(title: String?, author: String?, dateCreated: String?, imageLink: String?) {
        self.titleLabel?.text = title
        self.authorLabel?.text = author
        self.dateLabel?.text = dateCreated

        self.nasaImageView?.setImageWith(urlString: imageLink ?? "", {
            self.imageViewLoadingIndicator.stopAnimating()
            self.imageViewLoadingIndicator.isHidden = true
        })
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
