//
//  ViewController.swift
//  Searcher
//
//  Created by MacInnovacion on 03/09/20.
//  Copyright © 2020 none. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var fiveSelected: UIButton!
    @IBOutlet weak var tenSelected: UIButton!
    
    var searchManager = SearchManager()
    var items = ["Articulos..."]
    var itemsSelected = "0"
   
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        searchManager.delegate = self
        
        tableview.delegate = self
        tableview.dataSource = self
    }

    @IBAction func articulosSelected(_ sender: UIButton) {
        fiveSelected.isSelected = false
        tenSelected.isSelected = false
        sender.isSelected = true
        itemsSelected = sender.currentTitle!
    }
    

}


//MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
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
extension ViewController: SearchManagerDelegate{
    func didUpdateSearch(_ SearchManager: SearchManager, search: SearchModel) {
        DispatchQueue.main.async {
            print(search.productDisplayName)
        }
    }
    
    func didFailWitherror(error: Error) {
        print(error)
    }
}

//MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return items.count
    }
}

//MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "mycell")
        cell.textLabel?.text  = items[indexPath.row]
        
        //cell.imageView!.image = UIImage(named: items[indexPath.row])!
        return cell
    }
}

