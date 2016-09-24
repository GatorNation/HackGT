//
//  MotionInterfaceController.swift
//  HackGT-HealthKit
//
//  Created by David  Yeung on 9/24/16.
//  Copyright © 2016 David  Yeung. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion
import WatchConnectivity

class MotionInterfaceController: WKInterfaceController, WCSessionDelegate {

    let motionMgr = CMMotionManager()
    var session : WCSession!

    
    @IBOutlet var motionButton: WKInterfaceButton!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        self.checkAvailability()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if (WCSession.isSupported()) {
            session = WCSession.default()
            session.delegate = self
            session.activate()
        }

    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func checkAvailability()
    {
        var str:String = ""
        
        if (motionMgr.isAccelerometerAvailable)
        {
            str.append("a")
        }
        if (motionMgr.isMagnetometerAvailable)
        {
            str.append("m")
        }
        if (motionMgr.isGyroAvailable)
        {
            str.append("g")
        }
        if (motionMgr.isDeviceMotionAvailable)
        {
            str.append("d")
        }
        
        if (str == "")
        {
            print("Empty :(")
        }
        print("Available functions:\(str)")
    }
    
    func activateDeviceMotion()
    {
        motionMgr.deviceMotionUpdateInterval = 0.1
        motionMgr.startDeviceMotionUpdates(to: OperationQueue.main) { (motion, error) in
            let g = (motion?.gravity)!
            let acc = (motion?.userAcceleration)!
            print("Gravity: \(g) Acceleration: \(acc.x)")
        }
    }
    var indexCounter : Double = 0;
    var end: Double = 10;
    var previousValue : Double = 0
    
    func activateAccelerometer()
    {

        motionMgr.accelerometerUpdateInterval = 0.05
        motionMgr.startAccelerometerUpdates(to: OperationQueue.main) { (accel, error) in
            let currentValue : CMAcceleration = (accel?.acceleration)!;
            if(abs(currentValue.x - self.previousValue) >= 0.5)
            {
                self.previousValue = currentValue.x
                self.indexCounter += 1
                if (self.indexCounter == self.end)
                {
                    self.hasSeizure();
                }
            }
            
            
            print("Acceleration: x: \(currentValue.x) y: \(currentValue.y)", true);
            
            
        }
    }
    func hasSeizure()
    {
        let message = ["message":"Seizure Confirmed"]
        session.sendMessage(message, replyHandler: nil) { (error) in
                print("Error occured: \(error)")
        }
    }
    @IBAction func motionButtonPressed() {
        
        self.activateAccelerometer()
        //        self.activateDeviceMotion()
    }
    
    func readAccelerometerData()
    {
        if let data = motionMgr.accelerometerData
        {
            print("X acceleration: \(data.acceleration.x) Y acceleration: \(data.acceleration.y)")
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?){
    }
}
