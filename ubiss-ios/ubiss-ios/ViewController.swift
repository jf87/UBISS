//
//  ViewController.swift
//  ubiss-ios
//
//  Created by jofu on 10/06/15.
//  Copyright (c) 2015 ITU. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var textFieldName: UITextField!
    @IBOutlet var textFieldTel: UITextField!
    
    @IBOutlet var buttonDeactivate: UIButton!
    @IBOutlet var buttonActivate: UIButton!
    
    @IBAction func buttonAvtivated(sender: UIButton) {
        
        println("activated")
        self.buttonActivate.enabled = false
        self.buttonDeactivate.enabled = true

    }
    
    @IBAction func buttonDeactivated(sender: UIButton) {
        
        println("deactivated")
        self.buttonDeactivate.enabled = false
        self.buttonActivate.enabled = true

    }
    
    var locationManager: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        textFieldName!.delegate = self
        textFieldTel!.delegate = self
        self.buttonDeactivate.enabled = false

        

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        startLocation = nil

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func locationManager(manager: CLLocationManager!,
        didUpdateLocations locations: [AnyObject]!)
    {
        var latestLocation: AnyObject = locations[locations.count - 1]
        println(latestLocation.coordinate.latitude)
        println(latestLocation.coordinate.longitude)
        
        if startLocation == nil {
            startLocation = latestLocation as! CLLocation
        }
        
        var distanceBetween: CLLocationDistance =
        latestLocation.distanceFromLocation(startLocation)
        println(distanceBetween)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {    //delegate method
        println("textFieldDidBeginEditing")
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {  //delegate method
        println("textFieldShouldEndEditing")
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        println("textFieldShouldReturn")

        textField.resignFirstResponder()
        return true
    }



}

