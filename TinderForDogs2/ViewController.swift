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

class ViewController: UIViewController {
    
    @IBAction func dogButtonClicked(_ sender: UIButton) {
    }
    
    @IBOutlet weak var dogButton: UIButton!
    
    @IBOutlet weak var dogNameLabel: UILabel!
    
    @IBOutlet weak var dogBreedLabel: UILabel!
    
    @IBOutlet weak var dogDescriptionLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func noButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func chatButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func loveButtonPressed(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

