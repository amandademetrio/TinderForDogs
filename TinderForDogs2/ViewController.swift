//
//  ViewController.swift
//  TinderForDogs2
//
//  Created by Amanda Demetrio on 9/26/18.
//  Copyright © 2018 Amanda Demetrio. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import CoreLocation
import MessageUI

class ViewController: UIViewController {
    
    //Stagging area for stuff to be added to Core Data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let saveContext = (UIApplication.shared.delegate as! AppDelegate).saveContext
    
    var dogs: [NSDictionary] = []
    var dogNumber: Int = 0
    var savedDogs: [Dog] = []
    
    @IBOutlet weak var dogButton: UIButton!
    @IBOutlet weak var dogNameLabel: UILabel!
    @IBOutlet weak var dogBreedLabel: UILabel!
    @IBOutlet weak var dogDescriptionLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mainImageView: UIImageView!
    
    @IBAction func noButtonPressed(_ sender: UIButton) {
        markingPupAsNo(self.dogs[dogNumber])
        loadNextDog()
    }
    
    @IBAction func chatButtonPressed(_ sender: UIButton) {
        if self.dogs[dogNumber]["phone"] as! String == "N/A" {
            sendPupEmail(self.dogs[dogNumber]["email"] as! String,self.dogs[dogNumber]["name"] as! String)
        }
        else if self.dogs[dogNumber]["email"] as! String == "N/A" {
            sendPupCall(self.dogs[dogNumber]["phone"] as! String)
        }
    }
    
    @IBAction func loveButtonPressed(_ sender: UIButton) {
        addYesPupToCoreData(self.dogs[dogNumber])
        loadNextDog()
    }
    
    //Segue is currently attached to the button; need to change this
//    @IBAction func allPupsButtonPressed(_ sender: UIBarButtonItem) {
//        print("allpupspressed")
//        savedDogs = fetchSavedPups()
//        print(savedDogs)
//        if savedDogs.count == 0 {
//            print("saved dogs = nil")
//        }
//        else {
//            performSegue(withIdentifier: "AllPupsSegue", sender: nil)
//        }
//    }
    
    var locationManager: CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //location settings
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.delegate = self as? CLLocationManagerDelegate
        self.mapView.delegate = self
        
        TinderDogModel.getAllDogs { (data, response, error) in
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    if let results = jsonResult["dog"] as? NSArray {
                        for dog in results {
                            let dogDict = dog as! NSDictionary
                            self.dogs.append(dogDict)
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.dogNameLabel.text = self.dogs[self.dogNumber]["name"] as? String
                    self.dogBreedLabel.text = self.dogs[self.dogNumber]["breed"] as? String
                    self.dogDescriptionLabel.text = self.dogs[self.dogNumber]["description"] as? String
                    
                    //Setting pup location on the map
                    let lat = self.dogs[self.dogNumber]["lat"] as! Double
                    let long = self.dogs[self.dogNumber]["long"] as! Double
                    let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    let mapPoint = MKPointAnnotation()
                    mapPoint.coordinate = coordinates
                    self.mapView.addAnnotation(mapPoint)
                    self.mapView.setCenter(coordinates, animated: true)
                    let region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
                    self.mapView.setRegion(region, animated: true)
                    
                    //Setting up pup image
                    let imageUrl = self.dogs[self.dogNumber]["picture"] as? String
                    let url = URL(string:imageUrl!)
                    do {
                        //setting image from URL
                        let data = try Data(contentsOf: url!)
                        self.mainImageView.image = UIImage(data: data)
                        self.mainImageView.contentMode = .scaleAspectFit
                        
                        self.mainImageView.isUserInteractionEnabled = true
                        
                        let swipeRight = UISwipeGestureRecognizer(target:self, action: #selector(self.rightSwipe(Sender:)))
                        swipeRight.direction = UISwipeGestureRecognizerDirection.right
                        self.mainImageView.addGestureRecognizer(swipeRight)
                        
                        let swipeLeft = UISwipeGestureRecognizer(target:self, action: #selector(self.leftSwipe(Sender:)))
                        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
                        self.mainImageView.addGestureRecognizer(swipeLeft)
                    }
                    catch {
                        print(error)
                    }
                }
            }
            catch {
                print("Something went wrong")
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func rightSwipe(Sender: UISwipeGestureRecognizer) {
        addYesPupToCoreData(self.dogs[dogNumber])
        loadNextDog()
    }
    
    @objc func leftSwipe(Sender: UISwipeGestureRecognizer) {
        markingPupAsNo(self.dogs[dogNumber])
        loadNextDog()
    }
    
    func fetchSavedPups() -> [Dog] {
        var data:[Dog] = []
        
        let dogRequest: NSFetchRequest = Dog.fetchRequest()
        dogRequest.predicate = NSPredicate(format: "isLiked = true")
        do {
            let results = try context.fetch(dogRequest)
            for item in results {
                data.append(item)
            }
        }
        catch {
            print("Errors are \(error)")
        }
        
        return data
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tableVC = segue.destination as! TableViewController
        tableVC.delegate = self
        tableVC.dogs = fetchSavedPups()
    }
    
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        return annotationView
    }
}

extension ViewController: MFMailComposeViewControllerDelegate {
    
    func setPupInfo() {
        self.dogNameLabel.text = self.dogs[self.dogNumber]["name"] as? String
        self.dogBreedLabel.text = self.dogs[self.dogNumber]["breed"] as? String
        self.dogDescriptionLabel.text = self.dogs[self.dogNumber]["description"] as? String
        
        //Setting pup location on the map
        let lat = self.dogs[self.dogNumber]["lat"] as! Double
        let long = self.dogs[self.dogNumber]["long"] as! Double
        let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let mapPoint = MKPointAnnotation()
        mapPoint.coordinate = coordinates
        self.mapView.addAnnotation(mapPoint)
        self.mapView.setCenter(coordinates, animated: true)
        let region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        self.mapView.setRegion(region, animated: true)
        
        //Setting up pup image
        let imageUrl = self.dogs[self.dogNumber]["picture"] as? String
        let url = URL(string:imageUrl!)
        do {
            let data = try Data(contentsOf: url!)
            self.mainImageView.image = UIImage(data: data)
            self.mainImageView.contentMode = .scaleAspectFit
        }
        catch {
            print(error)
        }
    }
    
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
    
    func addYesPupToCoreData(_ dogDict: NSDictionary) {
        //Still need to make sure this work
        let pup = Dog(context: context)
        pup.dogID = dogDict["_id"] as? String
        pup.dogName = dogDict["name"] as? String
        pup.image = dogDict["picture"] as? String
        pup.dogPhone = dogDict["phone"] as? String
        pup.dogEmail = dogDict["email"] as? String
        pup.dogLat = (dogDict["lat"] as? Double)!
        pup.dogLong = (dogDict["long"] as? Double)!
        pup.isLiked = true
        saveContext()
    }
    
    //func load next dog
    func loadNextDog() {
        dogNumber += 1
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        self.viewDidLoad()
    }
    
    func markingPupAsNo(_ dogDict: NSDictionary) {
        //Still need to make sure this work
        let pup = Dog(context: context)
        pup.dogID = dogDict["_id"] as? String
        pup.dogName = dogDict["name"] as? String
        pup.image = dogDict["picture"] as? String
        pup.dogLat = (dogDict["lat"] as? Double)!
        pup.dogLong = (dogDict["long"] as? Double)!
        pup.isLiked = false
        saveContext()
    }
}

