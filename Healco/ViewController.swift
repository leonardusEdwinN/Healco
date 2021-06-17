//
//  ViewController.swift
//  Healco
//
//  Created by Edwin Niwarlangga on 09/06/21.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    var isSearching: Bool = false
    var foodNames: [String] = []
    var foods: [NSManagedObject] = []
    var filteredFoodNames: [String] = []
    
    @IBOutlet weak var foodSearchBar: UISearchBar!
    @IBOutlet weak var foodNameTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodSearchBar.delegate = self
        foodNameTableView.dataSource = self
        foodNameTableView.delegate = self
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching{
            return filteredFoodNames.count
        }
        else{
            return foodNames.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodNameCell", for: indexPath)
        if isSearching{
            cell.textLabel?.text = filteredFoodNames[indexPath.row]
        }
        else{
            cell.textLabel?.text = foodNames[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            isSearching = false
            foodNameTableView.reloadData()
        } else{
            isSearching = true
            filteredFoodNames = foodNames.filter{(name: String) -> Bool in return name.range(of: searchText, options:.caseInsensitive, range: nil, locale: nil) != nil}
            foodNameTableView.reloadData()
        }
    }
}
