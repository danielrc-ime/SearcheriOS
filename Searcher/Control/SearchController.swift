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
    var items = ["Articulos..."]
    var itemsSelected = "5"
   
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        searchManager.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
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

//MARK: - SearchManagerDelegate
extension SearchController: SearchManagerDelegate{
    func didFailWitherror(error: Error) {
        print(error)
    }
    
    func didUpdateSearch(_ SearchManager: SearchManager, search: [SearchModel]) {
        //clear array of items
        items = []
        
        DispatchQueue.main.async {
            for item in search {
                print(item.category)
                self.items.append(item.category)
            }
            self.tableView.reloadData()
        }
    }
}

//MARK: - UITableViewDataSource
extension SearchController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return items.count
    }
}

//MARK: - UITableViewDelegate
extension SearchController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "mycell")
        cell.textLabel?.text  = items[indexPath.row]
        
        //cell.imageView!.image = UIImage(named: items[indexPath.row])!
        return cell
    }
}

