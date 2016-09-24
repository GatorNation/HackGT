//
//  InterfaceController.swift
//  myHackGT WatchKit Extension
//
//  Created by Joe Nguyen on 9/24/16.
//  Copyright © 2016 Joe Nguyen. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import CoreMotion

class WatchController: WKInterfaceController, WCSessionDelegate {
    
    let motionManager = CMMotionManager()
    var xMotion = 0.0
    var yMotion = 0.0
    var zMotion = 0.0
    var index = 0;
    var end = 3;
    var timer = Timer()
    var SeizureWarning = 10.0

    @IBOutlet var topLabel: WKInterfaceLabel!
    @IBOutlet var warningLabel: WKInterfaceLabel!
    var counter = 0
    
    var session : WCSession!
    
    
    @IBAction func reset() {
        timer.invalidate()
        SeizureWarning = 10.0
//        topLabel.setText("You don't have a seizure")
        statusIs(status: "Normal")
        setWarningLabelText()
        checkAcceleration()
    }
    
    func setWarningLabelText() {
        warningLabel.setText(String(SeizureWarning))
    }
    
    override func willActivate() {
        super.willActivate()
        
        
        if (WCSession.isSupported()) {
            session = WCSession.default()
            session.delegate = self
            session.activate()
            
        }
        setUpLabels()
        
        checkAcceleration()
       
    }
    
    func setUpLabels()
    {
        self.statusIs(status: "Normal")
        warningLabel.setText("")
    }
    
    func statusIs(status : String)
    {
        topLabel.setText(status)
        switch status {
        case "Normal":
            topLabel.setTextColor(UIColor.green)
        case "Warning":
            topLabel.setTextColor(UIColor.yellow)
        case "Critical":
            topLabel.setTextColor(UIColor.red)
        default:
            print("Error in function call")
        }
    }
    func denySeizure(){
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
    }
    
    func timerAction() {
        SeizureWarning -= 1.0
        warningLabel.setText("\(SeizureWarning)")
        WKInterfaceDevice.current().play(.failure)
        if(SeizureWarning == 0.0){
            timer.invalidate()
            statusIs(status: "Critical")
            let ax = ["accelX":"I'm having a seizure!"]
            
            self.session.sendMessage(ax, replyHandler: { (_: [String : Any]) in
                
            }) { (Error) in
            }

        }
        //self.sendSMS()
    }
    
    func checkAcceleration() {
        motionManager.accelerometerUpdateInterval = 0.05
        motionManager.startAccelerometerUpdates(to: OperationQueue.main) { (accel, error) in
            var a : CMAcceleration = (accel?.acceleration)!;
            var xDiff = abs(a.x - self.xMotion)
            var yDiff = abs(a.y - self.yMotion)
            var zDiff = abs(a.z - self.zMotion)
            if(xDiff >= 0.5 || yDiff >= 0.5 || zDiff >= 0.5){
                self.xMotion = a.x
                self.yMotion = a.y
                self.zMotion = a.z
                self.index += 1
                if(self.index == self.end){
//                    self.topLabel.setText("Oh, shitt. I'm having a seizure")
                    self.statusIs(status: "Warning")
                    self.denySeizure()
                }
                
            }
            else{
                self.index = 0
                self.xMotion = a.x
                self.yMotion = a.y
                self.zMotion = a.z
            }
            
            
            
            //print("x: \(a.x) y: \(a.y)");
            print("x: \(xDiff) y: \(yDiff) z: \(zDiff)");
            if ((error) != nil)
            {
                print(error?.localizedDescription)
            }
        }

    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        motionManager.accelerometerUpdateInterval = 0.1

    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
       // motionManager.stopAccelerometerUpdates()

    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?){
        
    }
    
}
