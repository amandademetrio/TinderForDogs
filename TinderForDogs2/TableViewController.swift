//
//  TableViewController.swift
//  TinderForDogs2
//
//  Created by Amanda Demetrio on 9/27/18.
//  Copyright © 2018 Amanda Demetrio. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    var delegate: ViewController?
    var dogs: [Dog]?
    //handle cases with empty dogs

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dogs!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.dogNameLabel.text = dogs?[indexPath.row].dogName
        
        let imageUrl = dogs?[indexPath.row].image
        
        let url = URL(string:imageUrl!)
        do {
            let data = try Data(contentsOf: url!)
            cell.smallImageView.image = UIImage(data: data)
            cell.smallImageView.contentMode = .scaleAspectFit
        }
        catch {
            print("an error in putting image inside imageview")
        }
        return cell
    }

}
