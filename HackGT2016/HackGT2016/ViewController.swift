//
//  ViewController.swift
//  HackGT2016
//
//  Created by David  Yeung on 9/24/16.
//
//

import UIKit
import WatchConnectivity
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet weak var counterLabel: UILabel!
    var counterData = [String]()
    var session: WCSession!
    
    var longitude = Double()
    var latitude = Double()
    
    var locationManager = CLLocationManager()
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?){
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession){
        
    }
    
    func sessionDidDeactivate(_ session: WCSession){
        
    }





    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (WCSession.isSupported()) {
            session = WCSession.default()
//            session.delegate = self;
           // session.activate()
        }
//            sendSMS()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
            if locationManager.location != nil {
                latitude = locationManager.location!.coordinate.latitude
                longitude = locationManager.location!.coordinate.longitude
        print("Important. " + String(UIDevice.current.name) + " might be having a seizure at or around: https://www.google.com/maps/@\(latitude),\(longitude),17z")
        }
        
        self.counterLabel.reloadInputViews()
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        let counterValue = message["counterValue"] as? String
        
        //Use this to update the UI instantaneously (otherwise, takes a little while)
        DispatchQueue.main.async {
            self.counterLabel.text = counterValue!;
            print(counterValue!)
            self.counterLabel.reloadInputViews()
        }

    }
    func locateMe() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    func sendSMS()
    {
        
        let twilioSID = "AC59be109d20772f0032a741c0453199a2"
        let twilioSecret = "214e31ae411a750ead23cd6c8d1475de"
        
        //Note replace + = %2B , for To and From phone number
//        let fromNumber = "%2B17656263107"// actual number is +14803606445
        let fromNumber = "%217656263107"// actual number is +14803606445
//        let toNumber = "%2B3522133462"// actual number is +919152346132
//        let toNumber = "%2B9045132487"// actual number is +919152346132
        let toNumber = "%2B9047181398"// actual number is +919152346132
        let message = String(UIDevice.current.name) + " might be having a seizure at "
        // Build the request
        let request = NSMutableURLRequest(url: NSURL(string:"https://\(twilioSID):\(twilioSecret)@api.twilio.com/2010-04-01/Accounts/\(twilioSID)/SMS/Messages")! as URL)
        request.httpMethod = "POST"
        request.httpBody = "From=\(fromNumber)&To=\(toNumber)&Body=\(message)".data(using: String.Encoding.utf8)
        
        // Build the completion block and send the request
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            print("Finished")
            if let data = data, let responseDetails = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                // Success
                print("Response: \(responseDetails)")
            } else {
                // Failure
                print("Error: \(error)")
            }
        }).resume()
    }
    
}

