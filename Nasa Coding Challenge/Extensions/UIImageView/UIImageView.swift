//
//  UIImageView.swift
//  Nasa Coding Challenge
//
//  Created by Idris Sop on 2021/05/08.
//

import UIKit

extension UIImageView {

    typealias ImageViewCallback = () -> (Void)
    private static var displayImageCallback: ImageViewCallback?
    
    func setImageWith(urlString: String, _ completionHandler: @escaping(ImageViewCallback) = { }) {
        UIImageView.displayImageCallback = completionHandler
        guard let url = URL(string: urlString) else { return }
        downloaded(from: url, contentMode: .scaleAspectFill)
    }
    
    private func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
                UIImageView.displayImageCallback?()
            }
        }.resume()
    }
    
    private func downloaded(from link: String) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: .scaleAspectFill)
    }
}
