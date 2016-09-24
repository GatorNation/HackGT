//
//  MainScrollViewController.swift
//  HackGT-HealthKit
//
//  Created by David  Yeung on 9/24/16.
//  Copyright © 2016 David  Yeung. All rights reserved.
//

import UIKit

class MainScrollViewController: UIViewController {
    @IBOutlet var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: self.view.frame.size.width * 2, height: self.view.frame.size.height)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let homeVC = HomeViewController()
        homeVC.view.frame.size = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height)
        scrollView.addSubview(homeVC.view)
        
        self.addChildViewController(homeVC)
        homeVC.didMove(toParentViewController: self)
        
        let contactInfoVC = ContactInfoViewController()
        contactInfoVC.view.frame.size = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height)
        scrollView.addSubview(contactInfoVC.view)
        contactInfoVC.view.frame.origin.x = self.view.frame.size.width
        self.addChildViewController(contactInfoVC)
        contactInfoVC.didMove(toParentViewController: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
