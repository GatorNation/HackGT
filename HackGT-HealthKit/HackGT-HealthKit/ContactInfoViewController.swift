//
//  ContactInfoViewController.swift
//  HackGT-HealthKit
//
//  Created by David  Yeung on 9/24/16.
//  Copyright © 2016 David  Yeung. All rights reserved.
//

import UIKit
import CoreData

class ContactInfoViewController: UIViewController {
    let contact = "contactNumber"
    
    @IBOutlet var topLabel: UILabel!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.hasStoredInfo()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let width = submitButton.frame.size.width/2;
        submitButton.layer.cornerRadius = width;
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnPressed(_ sender: AnyObject) {
        //Store information in textField to core data
        
        if let phoneNumber:String = textField.text , isValidPhoneNumber(phone: phoneNumber)
        {
                self.storeInfo(str: textField.text!)
        }
        else
        {
            let alert = UIAlertController(title: "Alert", message: "Please enter correct number", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            textField.text = "" //clears the text
        }
    }
    
    func isValidPhoneNumber(phone: String) -> Bool
    {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: phone)
        
        let PHONE_REGEX2 = "^\\d{3}\\d{3}\\d{4}$"
        let phoneTest2 = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX2)
        let result2 =  phoneTest2.evaluate(with: phone)
        
        return (result || result2)
    }
    
    //If false
    func hasStoredInfo() -> Bool
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        //2
        let entity =  NSEntityDescription.entity(forEntityName: "User", in: context)
        
        let user = NSManagedObject(entity: entity!, insertInto:context)
        
        if let number:String = user.value(forKey: contact) as! String?
        {
            textField.text = number
            textField.isUserInteractionEnabled = false
            return true
        }
        return false
    }
    
    func storeInfo(str : String)
    {
        if (!str.isEmpty){
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

            //2
            let entity =  NSEntityDescription.entity(forEntityName: "User", in: context)

            let user = NSManagedObject(entity: entity!, insertInto: context)
            
            //3
            user.setValue(str, forKey: contact)
            
            //4
            do {
                try context.save()
                //5
                
                self.successfullyUpdated()

            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }
    
    func successfullyUpdated()
    {
        let alert = UIAlertController(title: "Success", message: "Successfully finished", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        submitButton.isEnabled = false;
        textField.isEnabled = false;
        
        if (hasStoredInfo())
        {
            print("StoredInfo succeed")
        }
        else
        {
            print("")
        }
        
    }
    
}
