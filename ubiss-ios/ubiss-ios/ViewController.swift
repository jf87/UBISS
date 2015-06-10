//
//  ViewController.swift
//  ubiss-ios
//
//  Created by jofu on 10/06/15.
//  Copyright (c) 2015 ITU. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftHTTP

class ViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var textFieldName: UITextField!
    @IBOutlet var textFieldTel: UITextField!
    
    @IBOutlet var buttonDeactivate: UIButton!
    @IBOutlet var buttonActivate: UIButton!
    
    var locationManager: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!
    var distanceBetween : CLLocationDistance = 0
    var uuid : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        uuid = NSUUID().UUIDString


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
        
        if  (latestLocation.distanceFromLocation(startLocation) > 1) {
            distanceBetween = latestLocation.distanceFromLocation(startLocation)
            startLocation = latestLocation as! CLLocation
            println("volunteer moved: \(distanceBetween)")
            
            var request = HTTPTask()
            //we have to add the explicit type, else the wrong type is inferred. See the vluxe.io article for more info.
            let params: Dictionary<String,AnyObject> = ["uuid": uuid, "lo": latestLocation.coordinate.longitude, "la": latestLocation.coordinate.latitude]
            request.POST("http://httpbin.org/post", parameters: params, completionHandler: {(response: HTTPResponse) in
                if let err = response.error {
                    println("error: \(err.localizedDescription)")
                    return //also notify app of failure as needed
                }
                if let res: AnyObject = response.responseObject {
                    println("response: \(res)")
                    println("description: \(response.description)")
                }
            })
            
            
        }
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        println("textFieldDidBeginEditing")
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        println("textFieldShouldEndEditing")
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        println("textFieldShouldReturn")
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func buttonAvtivated(sender: UIButton) {
        
        println("activated")
        self.buttonActivate.enabled = false
        self.buttonDeactivate.enabled = true
        
        let name : String = self.textFieldName.text
        let tel : String = self.textFieldTel.text
        
        var request = HTTPTask()
        //we have to add the explicit type, else the wrong type is inferred. See the vluxe.io article for more info.
        let params: Dictionary<String,AnyObject> = ["uuid": uuid, "name": name, "tel": tel]
        request.POST("http://httpbin.org/post", parameters: params, completionHandler: {(response: HTTPResponse) in
            if let err = response.error {
                println("error: \(err.localizedDescription)")
                return //also notify app of failure as needed
            }
            if let res: AnyObject = response.responseObject {
                println("response: \(res)")
                println("description: \(response.description)")
            }
        })
    }
    
    @IBAction func buttonDeactivated(sender: UIButton) {
        
        println("deactivated")
        self.buttonDeactivate.enabled = false
        self.buttonActivate.enabled = true
        var request = HTTPTask()
        //we have to add the explicit type, else the wrong type is inferred. See the vluxe.io article for more info.
        let params: Dictionary<String,AnyObject> = ["status": 0]
        request.POST("http://httpbin.org/post", parameters: params, completionHandler: {(response: HTTPResponse) in
            if let err = response.error {
                println("error: \(err.localizedDescription)")
                return //also notify app of failure as needed
            }
            if let res: AnyObject = response.responseObject {
                println("response: \(res)")
                println("description: \(response.description)")
            }
        })

        
    }




}

