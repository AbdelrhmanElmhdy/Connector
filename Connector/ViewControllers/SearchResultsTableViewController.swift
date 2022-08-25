//
//  SearchResultsTableViewController.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 14/07/2022.
//

import UIKit

let cellsReuseIdentifier = "cellsReuseIdentifier"

class SearchResultsTableViewController: UITableViewController {
    
    var delegate: SearchResultsControllerDelegate?
    
    var people: [User] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        tableView.register(SearchResultsTableViewCell.self, forCellReuseIdentifier: cellsReuseIdentifier)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return people.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellsReuseIdentifier, for: indexPath) as! SearchResultsTableViewCell

        cell.viewModel = people[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectPerson(person: people[indexPath.row])
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }

}
