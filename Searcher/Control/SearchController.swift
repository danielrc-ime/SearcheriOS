//
//  ViewController.swift
//  Searcher
//
//  Created by MacInnovacion on 03/09/20.
//  Copyright © 2020 none. All rights reserved.
//

import UIKit

class SearchController: UIViewController {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var fiveSelected: UIButton!
    @IBOutlet weak var tenSelected: UIButton!
    
    var searchManager = SearchManager()
    var tituloArray = ["Articulos..."]
    var precioArray = ["Titulo..."]
    var ubicacionArray = ["Categoría..."]
    var imageArray: [UIImage] = []
    var imagesString = ["urls"]
    var itemsSelected = "5"
    
    let cellReuseIdentifier = "cell"
   
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        searchManager.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        imageArray.append(UIImage(systemName: "xmark.icloud")!)
    }

    @IBAction func articulosSelected(_ sender: UIButton) {
        fiveSelected.isSelected = false
        tenSelected.isSelected = false
        sender.isSelected = true
        itemsSelected = sender.currentTitle!
    }
    

}


//MARK: - UITextFieldDelegate
extension SearchController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Escribe lo que buscas: \"Pantalla\""
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let search = searchTextField.text {
            searchManager.fetchSearch(criterio: search, pagina: "1", items: itemsSelected)
        }
        searchTextField.text = ""
    }
}

//MARK: - UIImageView Load fromURL
extension UIImageView {

public func imageFromServerURL(urlString: String, PlaceHolderImage:UIImage) {

       if self.image == nil{
             self.image = PlaceHolderImage
       }

       URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in

           if error != nil {
               print(error ?? "No Error")
               return
           }
           DispatchQueue.main.async(execute: { () -> Void in
               let image = UIImage(data: data!)
               self.image = image
           })

       }).resume()
   }}

//MARK: - SearchManagerDelegate
extension SearchController: SearchManagerDelegate{
    func didFailWitherror(error: Error) {
        print(error)
    }
    
    func didUpdateSearch(_ SearchManager: SearchManager, search: [SearchModel]) {
        //clear array of items
        tituloArray = []
        precioArray = []
        ubicacionArray = []
        imagesString = []
        
        DispatchQueue.main.async {
            for item in search {
                print(item.category)
                self.tituloArray.append(item.productDisplayName)
                self.precioArray.append(item.precio)
                self.ubicacionArray.append(item.category)
                self.imagesString.append(item.smImage)
            }
            self.tableView.reloadData()
        }
    }
}

//MARK: - UITableViewDataSource
extension SearchController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return tituloArray.count
    }
}

//MARK: - UITableViewDelegate
extension SearchController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:CustomTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! CustomTableViewCell
        cell.tituloLabel?.text = tituloArray[indexPath.row]
        cell.precioLabel?.text = "$" + precioArray[indexPath.row]
        cell.ubicacionLabel?.text = "Categoría: " + ubicacionArray[indexPath.row]
        cell.cellImageView?.imageFromServerURL(urlString: imagesString[indexPath.row], PlaceHolderImage: UIImage(systemName: "xmark.icloud")!)
        return cell
    }
}

