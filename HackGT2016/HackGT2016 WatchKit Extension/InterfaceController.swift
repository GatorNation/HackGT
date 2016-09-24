//
//  InterfaceController.swift
//  HackGT2016 WatchKit Extension
//
//  Created by David  Yeung on 9/24/16.
//
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet var counterLabel: WKInterfaceLabel!
    var counter = 0
    
    var session : WCSession!
    
    @IBAction func incrementCounter() {
        counter += 1
        setCounterLabelText()
    }
    
    @IBAction func clearCounter() {
        counter = 0
        setCounterLabelText()
    }
    
    @IBAction func saveCounter() {
        let applicationData = ["counterValue":String(counter)]
        
        session.sendMessage(applicationData, replyHandler: { (_: [String : Any]) in
    
            }) { (Error) in
        }
    }
    
    func setCounterLabelText() {
        counterLabel.setText(String(counter))
    }
    
    override func willActivate() {
        super.willActivate()
        
        if (WCSession.isSupported()) {
            session = WCSession.default()
            session.delegate = self
            session.activate()
        }
    }

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?){
        
    }
    
    
    


}
