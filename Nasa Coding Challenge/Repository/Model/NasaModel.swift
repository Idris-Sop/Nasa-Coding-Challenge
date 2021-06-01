//
//  NasaModel.swift
//  Nasa Coding Challenge
//
//  Created by Idris Sop on 2021/05/10.
//

import UIKit

struct NasaModel: Codable, Equatable {
    var imageLink: String?
    var nasaId: String?
    var nasaDescription: String?
    var dateCreated: String?
    var title: String?
    var photographer: String?
    var keywords: [String]?
}
