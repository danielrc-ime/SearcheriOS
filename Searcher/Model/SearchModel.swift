//
//  SearchModel.swift
//  Searcher
//
//  Created by MacInnovacion on 03/09/20.
//  Copyright © 2020 none. All rights reserved.
//

import Foundation
import UIKit

struct SearchModel {
        
    let productDisplayName: String
    let promoPrice: Double
    let category: String
    let smImage: String
    
    var precio: String {
        return String(format: "%0.2f", promoPrice)
    }
    
}
