//
//  TableViewController.swift
//  TinderForDogs2
//
//  Created by Amanda Demetrio on 9/27/18.
//  Copyright © 2018 Amanda Demetrio. All rights reserved.
//

import UIKit
import CoreData
import MessageUI

class TableViewController: UITableViewController {
    
    //Stagging area for stuff to be added to Core Data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let saveContext = (UIApplication.shared.delegate as! AppDelegate).saveContext
    
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
        cell.indexPath = indexPath
        cell.delegate = self
        let imageUrl = dogs?[indexPath.row].image
        let url = URL(string:imageUrl!)
       
        DispatchQueue.main.async {
            do {
                let data = try Data(contentsOf: url!)
                cell.smallImageView.image = UIImage(data: data)
                cell.smallImageView.contentMode = .scaleAspectFit
            }
            catch {
                print("an error in putting image inside imageview")
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doggy = dogs![indexPath.row]
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, done) in
            self.context.delete(doggy)
            self.saveContext()
            self.dogs?.remove(at: indexPath.row)
            tableView.reloadData()
            done(true)
        }
        delete.image = UIImage(named: "delete")
        let actions:[UIContextualAction] = [delete]
        return UISwipeActionsConfiguration(actions: actions)
    }
}

extension TableViewController: CustomCellDelegate {
    func sendEmailButtonClick(_ indexPath: IndexPath) {
        let doggy = dogs![indexPath.row]
        if doggy.dogEmail! == "N/A" {
            let alert = UIAlertController(title: "Sorry!", message: "This pup has no email available", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else {
           sendPupEmail(doggy.dogEmail!,doggy.dogName!)
        }
    }
    
    func sendCallButtonClick(_ indexPath: IndexPath) {
        let doggy = dogs![indexPath.row]
        if doggy.dogPhone! == "N/A" {
            let alert = UIAlertController(title: "Sorry!", message: "This pup has no phone number available", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            sendPupCall(doggy.dogPhone!)
        }
    }
}

extension TableViewController: MFMailComposeViewControllerDelegate {
    func sendPupEmail (_ email: String,_ name: String) {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        composeVC.setToRecipients([email])
        composeVC.setSubject("Interested in \(name)")
        present(composeVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func sendPupCall(_ phoneString: String) {
        let url = URL(string: "telprompt://\(phoneString)")
        UIApplication.shared.open(url!)
    }
}

extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        self.image = nil
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print("error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }
}
