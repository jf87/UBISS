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
import Alamofire

class MainViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!
    var distanceBetween : CLLocationDistance = 0
    var uuid : String = ""
    let REST : String = "http://188.166.122.113:5000"
    let defaults = NSUserDefaults.standardUserDefaults()

    var availableButton   = UIButton()
    var unavailableButton = UIButton()
    var nameTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let size : CGFloat = 140
        let screenWidth  : CGFloat = self.view.frame.size.width

        // Create UI elements
        
        nameTextField.frame = CGRectMake((screenWidth / 2) - (size / 2), 140, size, 30)
        nameTextField.borderStyle = UITextBorderStyle.Line
        self.view.addSubview(nameTextField)

        
        
        availableButton   = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        availableButton.frame = CGRectMake((screenWidth / 2) - (size / 2), 180, size, 30)
        availableButton.setTitle("Available", forState: UIControlState.Normal)
        availableButton.addTarget(self, action: "availableButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(availableButton)

        unavailableButton   = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        unavailableButton.frame = CGRectMake((screenWidth / 2) - (size / 2), 220, size, 30)
        unavailableButton.setTitle("Unavailable", forState: UIControlState.Normal)
        unavailableButton.addTarget(self, action: "unavailableButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(unavailableButton)
        
        
        uuid = NSUUID().UUIDString
        uuid = "FB090EAF-79B2-475E-B52F-71110D5F5E10"
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), backgroundGETs)
        
        
        nameTextField.delegate = self
//        textFieldTel!.delegate = self
//        self.buttonDeactivate.enabled = false
        
        
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        startLocation = nil
        if let name = defaults.stringForKey("userNameKey")
        {
            self.nameTextField.text = name
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //button actions
    func availableButtonAction(sender:UIButton!)
    {
        println("availableButtonAction tapped")
        var name : String = ""
        if var name = defaults.stringForKey("userNameKey")
        {
            println(name)
            var name = defaults.stringForKey("userNameKey")
            
        } else{
            defaults.setObject(self.nameTextField.text, forKey: "userNameKey")
            var name : String = self.nameTextField.text
        }
        self.availableButton.enabled = false
        
        let parameters = [
            "volunteer_id": uuid,
            "nickname": name
        ]
        println(parameters)
        Alamofire.request(.POST, self.REST+"/volunteers/", parameters: parameters, encoding: .JSON)
            .response { (request, response, data, error) in
                println("newuser")
                println(request)
                println(response)
                println(response?.description)
                println(error)
        }
        self.unavailableButton.enabled = true

    }

    func unavailableButtonAction(sender:UIButton!)
    {
        println("unavailableButtonAction tapped")
        self.unavailableButton.enabled = false
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
        self.availableButton.enabled = true

    }


    func backgroundGETs() {
        NSThread.sleepForTimeInterval(10)
        println("this is background task")
        var request = HTTPTask()
        request.GET(self.REST+"/volunteers", parameters: nil, completionHandler: {(response: HTTPResponse) in
            if let err = response.error {
                println("error: \(err.localizedDescription)")
                return //also notify app of failure as needed
            }
            if let data = response.responseObject as? NSData {
                let str = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("response: \(str)") //prints the HTML of the page
                dispatch_async(dispatch_get_main_queue(),{
                    //do UI changes to tableview
                })
            }
        })
        
        //call again
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), backgroundGETs)
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
        
        if  (latestLocation.distanceFromLocation(startLocation) > 2) && self.unavailableButton.enabled {
            distanceBetween = latestLocation.distanceFromLocation(startLocation)
            startLocation = latestLocation as! CLLocation
            println("volunteer moved: \(distanceBetween)")
            let parameters = [
                "longitude": latestLocation.coordinate.longitude,
                "latitude": latestLocation.coordinate.latitude
            ]
            Alamofire.request(.POST, self.REST+"/volunteers/"+uuid+"/location", parameters: parameters, encoding: .JSON)
                .response { (request, response, data, error) in
                    println("AlamofireLoc")
                    println(request)
                    println(response)
                    println(error)
            }
            
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
}

