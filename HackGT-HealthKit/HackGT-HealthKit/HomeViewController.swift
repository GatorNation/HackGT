//
//  HomeViewController.swift
//  HackGT-HealthKit
//
//  Created by David  Yeung on 9/24/16.
//  Copyright © 2016 David  Yeung. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var phoneNumber: UILabel!
    @IBOutlet var phoneIcon: UIImageView!
    @IBOutlet var editButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setUpView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpView()
    {
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        editButton.layer.cornerRadius = editButton.frame.size.width/8
        phoneNumber.layer.cornerRadius = phoneNumber.frame.size.width/8
    }
    
    @IBAction func editButtonPressed(_ sender: AnyObject) {
        //GoToEdit number
    }
}
