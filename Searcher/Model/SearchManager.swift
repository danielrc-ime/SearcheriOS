//
//  SearchManager.swift
//  Searcher
//
//  Created by MacInnovacion on 03/09/20.
//  Copyright © 2020 none. All rights reserved.
//

import Foundation

protocol SearchManagerDelegate {
    func didUpdateSearch(_ SearchManager: SearchManager, search: [SearchModel])
    func didFailWitherror(error: Error)
}

struct SearchManager {
    
    var delegate: SearchManagerDelegate?
    
    func fetchSearch(criterio: String, pagina: String, items: String){
        let urlString = "https://shoppapp.liverpool.com.mx/appclienteservices/services/v3/plp?force-plp=true&search-string=\(criterio)&page-number=\(pagina)&number-of-items-per-page=\(items)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        //First Create URL
        if let url = URL(string: urlString){
            //Second URLSession
            let session = URLSession(configuration: .default)
            //Third Give URLSession a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    //print(error!)
                    self.delegate?.didFailWitherror(error: error!)
                    return
                }
                if let safeData = data {
                    //print(String(data: safeData, encoding: .utf8))
                    if let search = self.parseJSON(safeData) {
                        self.delegate?.didUpdateSearch(self, search: search)
                    }
                }
            }
            //Fourth Start the Task
            task.resume()
        }
    }

    func parseJSON(_ searchData: Data) -> [SearchModel]?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(SearchData.self, from: searchData)
            
            var search: [SearchModel] = []
            
            for item in decodedData.plpResults.records {
                search.append(SearchModel(productDisplayName: item.productDisplayName, promoPrice: item.promoPrice, category: item.category, smImage: item.smImage))
                print(item.productDisplayName)
            }
            return search
        } catch {
            //print(error)
            delegate?.didFailWitherror(error: error)
            return []
        }
    }
    
}
