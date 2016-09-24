//
//  InterfaceController.swift
//  HackGT2016 WatchKit Extension
//
//  Created by David  Yeung on 9/24/16.
//
//

import WatchKit
import Foundation
import CoreMotion

class InterfaceController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func checkSeizure(){
            let manager = CMMotionManager()
            if (manager.isGyroAvailable && manager.isAccelerometerAvailable){
                manager.gyroUpdateInterval = 0.01
                manager.accelerometerUpdateInterval = 0.01
                manager.startGyroUpdates()
                manager.startAccelerometerUpdates()
                var accelerometerData: CMAccelerometerData?
                var gyroData: CMGyroData?
                
                
            }
        
    }
}
