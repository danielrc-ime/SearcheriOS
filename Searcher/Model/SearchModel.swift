//
//  SearchModel.swift
//  Searcher
//
//  Created by MacInnovacion on 03/09/20.
//  Copyright © 2020 none. All rights reserved.
//

import Foundation
import UIKit

protocol GetImageFromURLDelegate {
    func didImageLoad(_ image: UIImage)
    func didFailWitherror(_ error: Error)
}

struct SearchModel {
    
    var delegate: GetImageFromURLDelegate?
    
    let productDisplayName: String
    let promoPrice: Double
    let category: String
    let smImage: String
    //var imagen: UIImage?//(systemName: "xmark.icloud")
    
    var precio: String {
        return String(format: "%0.2f", promoPrice)
    }
    
//    mutating func imagenURL (image: UIImage){
//        imagen = image
//    }
}
