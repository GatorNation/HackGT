//
//  ViewController.swift
//  HackGT2016
//
//  Created by David  Yeung on 9/24/16.
//
//

import UIKit
import WatchConnectivity
import CoreMotion

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Sending a request message to watch between taps
    //If the Watch is unavailable -> error.
    @IBAction func backToWatchBwTap(_ sender: UIButton!){
        if !WCSession.default().isReachable{
            
            let alert = UIAlertController(
                title: "Send failed.",
                message: "Apple Watch is unreachable.",
                preferredStyle: UIAlertControllerStyle.alert)
            let oK = UIAlertAction(
                title: "OK",
                style: UIAlertActionStyle.cancel,
                handler: nil)
            alert.addAction(oK)
            present(alert, animated: true, completion: nil)
            
            return
        }
        
        let msg = ["request": "showAlert"]
        WCSession.default().sendMessage(
            msg, replyHandler: { (replyMessage) -> Void in
        }) { (error) -> Void in
                print(error)
        }
        
    }
    
 

    

}

