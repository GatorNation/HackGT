//
//  SendToPhoneInterfaceController.swift
//  HackGT-HealthKit
//
//  Created by David  Yeung on 9/24/16.
//  Copyright © 2016 David  Yeung. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class SendToPhoneInterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var sendToIPhone: WKInterfaceButton!
    var session : WCSession!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
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
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?){
        
    }

    @IBAction func sendButtonPressed() {
        session.sendMessage(["send": "testSent"], replyHandler: nil) { (error) in
            print("Watch sent an error \(error)")
        }
    }

}
