//
//  SearchModel.swift
//  Searcher
//
//  Created by MacInnovacion on 03/09/20.
//  Copyright © 2020 none. All rights reserved.
//

import Foundation
import UIKit

protocol GetImageFromURL {
    func didImageLoad(_ image: UIImage)
    func didFailWitherror(error: Error)
}

struct SearchModel {
    
    var delegate: GetImageFromURL?
    
    let productDisplayName: String
    let promoPrice: Double
    let category: String
    let smImage: String
    
    var precio: String {
        return String(format: "%0.2f", promoPrice)
    }
    
//    var imagen: UIImage{
//        getImage(urlImage: smImage)
//    }
    
    func getImage(urlImage: String) {
        let catPictureURL = URL(string: urlImage)!

        // Creating a session object with the default configuration.
        // You can read more about it here https://developer.apple.com/reference/foundation/urlsessionconfiguration
        let session = URLSession(configuration: .default)

        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
        let downloadPicTask = session.dataTask(with: catPictureURL) { (data, response, error) in
            // The download has finished.
            if error != nil {
                print("Error downloading cat picture: \(String(describing: error))")
                self.delegate?.didFailWitherror(error: error!)
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded cat picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        let image = UIImage(data: imageData)
                        // Do something with your image.
                        self.delegate?.didImageLoad(image!)
                    } else {
                        print("Couldn't get image: Image is nil")
                        self.delegate?.didImageLoad(UIImage(systemName: "xmark.icloud")!)
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }

        downloadPicTask.resume()
    }
}
