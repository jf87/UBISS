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

class ViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var textFieldName: UITextField!
    @IBOutlet var textFieldTel: UITextField!
    
    @IBOutlet var buttonDeactivate: UIButton!
    @IBOutlet var buttonActivate: UIButton!
    
    var locationManager: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!
    var distanceBetween : CLLocationDistance = 0
    var uuid : String = ""
    let REST : String = "http://130.226.142.195/ubiss"

    override func viewDidLoad() {
        super.viewDidLoad()
        uuid = NSUUID().UUIDString
//        dispatch_async(dispatch_get_global_queue(priority, 0)) {
//            // do some task
//            dispatch_async(dispatch_get_main_queue()) {
//                // update some UI
//            }
//        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), backgroundGETs)

        
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
    
    func backgroundGETs() {
        NSThread.sleepForTimeInterval(5)
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
        
        if  (latestLocation.distanceFromLocation(startLocation) > 2) && self.buttonDeactivate.enabled{
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
    
    
    @IBAction func buttonAvtivated(sender: UIButton) {
        
        println("activated")
        self.buttonActivate.enabled = false
        
        let name : String = self.textFieldName.text
        let tel : String = self.textFieldTel.text
        let parameters = [
            "volunteer_id": uuid,
            "nickname": name
        ]
        Alamofire.request(.POST, REST+"/volunteers", parameters: parameters, encoding: .JSON)
            .response { (request, response, data, error) in
                println("Alamofire")
                println(request)
                println(response)
                println(error)
        }
        self.buttonDeactivate.enabled = true

        
    }
    
    @IBAction func buttonDeactivated(sender: UIButton) {
        
        println("deactivated")
        self.buttonDeactivate.enabled = false
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
        self.buttonActivate.enabled = true
    }




}

