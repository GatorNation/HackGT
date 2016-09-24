//
//  ViewController.swift
//  HackGT-HealthKit
//
//  Created by David  Yeung on 9/24/16.
//  Copyright © 2016 David  Yeung. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController {

    @IBOutlet var startButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
               // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let width = startButton.frame.size.width/2;
        startButton.layer.cornerRadius = width;

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

