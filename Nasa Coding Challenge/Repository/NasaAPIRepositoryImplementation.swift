//
//  NasaAPIRepositoryImplementation.swift
//  Nasa Coding Challenge
//
//  Created by Idris Sop on 2021/05/10.
//

import UIKit

class NasaAPIRepositoryImplementation: NasaAPIRepository {

    func retrieveNasaList(with success: @escaping RetrieveNasaListCompletionBlock,
                          failure: @escaping CompletionFailureBlock) {
        let webServiceManager = WebServicesManager()
        webServiceManager.performServerOperationWithURLRequest(stringURL: "https://images-api.nasa.gov/search?q=\"",
                                                               bodyRequestParameter: nil,
                                                               httpMethod: "GET",
                                                               httpHeaderField: nil,
                                                               success: { (data) in
                                                                do {
                                                                    var nasaList = [NasaModel]()
                                                                    let jsonObject = try JSONSerialization.jsonObject(with: data! as Data, options: []) as? [String : Any]
                                                                    let collectionObject = jsonObject?["collection"] as? [String : Any]
                                                                    if let itemsList = collectionObject?["items"] as? Array<Any> {
                                                                        for(_, nasa) in (itemsList.enumerated()) {
                                                                            
                                                                            if let currentNasa = nasa as? [String : Any] {
                                                                                guard let links = currentNasa["links"] as? Array<Any> else { return }
                                                                                guard let data = currentNasa["data"] as? Array<Any> else { return }
                                                                                
                                                                                guard let linksObject = links.first as? [String : Any] else { return }
                                                                                guard let dataObject = data.first as? [String : Any] else { return }
                                                                                
                                                                                let nasaModel = NasaModel(imageLink: linksObject["href"] as? String, nasaId: dataObject["nasa_id"] as? String, nasaDescription: dataObject["description"] as? String, dateCreated: dataObject["date_created"] as? String, title: dataObject["title"] as? String, photographer: dataObject["photographer"] as? String, keywords: dataObject["keywords"] as? [String])
                                                                                nasaList.append(nasaModel)
                                                                            }
                                                                            
                                                                        }
                                                                    }

                                                                    success(nasaList)
                                                                } catch  {
                                                                    let dataError = NSError(domain: "The data couldn’t be read due to technical problem.", code: 0, userInfo: nil)
                                                                    failure(dataError)
                                                                }
                                                                
        }) { (error) in
            failure(error ?? NSError())
        }
    }
}
