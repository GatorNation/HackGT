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
import HealthKit

class InterfaceController: WKInterfaceController {

    //Properties
    
    @IBOutlet var mainLabel: WKInterfaceLabel!
    var motionMgr = CMMotionManager()
    let healthStore = HKHealthStore()
    
    var session : HKWorkoutSession?
    let heartRateUnit = HKUnit(from: "count/min")
    var currenQuery : HKQuery?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        var status = "";
        
        if (motionMgr.isAccelerometerAvailable)
        {
            status.append("A")
        }
        if (motionMgr.isGyroAvailable)
        {
            status.append("G")
        }
        if (motionMgr.isMagnetometerAvailable)
        {
            status.append("M")
        }
        if (motionMgr.isDeviceMotionAvailable)
        {
            status.append("D")
        }
        mainLabel.setText(status)
        self.activateHeartRate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func activateHeartRate()
    {
        guard HKHealthStore.isHealthDataAvailable() == true else {
            mainLabel.setText("not available")
            return
        }
        
        guard let quantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate) else {
            mainLabel.setText("not allowed")
            return
        }
        
        let dataTypes = Set(arrayLiteral: quantityType)
        healthStore.requestAuthorization(toShare: nil, read: dataTypes) { (success, error) -> Void in
            if success == false {
                self.mainLabel.setText("not allowed")
            }
        }

    }
    
    
    func workoutDidStart(_ date : Date) {
        if let query = createHeartRateStreamingQuery(date) {
            self.currenQuery = query
            healthStore.execute(query)
        } else {
            mainLabel.setText("cannot start")
        }
    }
    
    func createHeartRateStreamingQuery(_ workoutStartDate: Date) -> HKQuery? {
        
        guard let quantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate) else { return nil }
        let datePredicate = HKQuery.predicateForSamples(withStart: workoutStartDate, end: nil, options: .strictEndDate )
        //let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates:[datePredicate])
        
        
        let heartRateQuery = HKAnchoredObjectQuery(type: quantityType, predicate: predicate, anchor: nil, limit: Int(HKObjectQueryNoLimit)) { (query, sampleObjects, deletedObjects, newAnchor, error) -> Void in
            self.updateHeartRate(sampleObjects)
        }
        
        heartRateQuery.updateHandler = {(query, samples, deleteObjects, newAnchor, error) -> Void in
            //self.anchor = newAnchor!
            self.updateHeartRate(samples)
        }
        return heartRateQuery
    }
    
    func updateHeartRate(_ samples: [HKSample]?) {
        guard let heartRateSamples = samples as? [HKQuantitySample] else {return}
        
        DispatchQueue.main.async {
            guard let sample = heartRateSamples.first else{return}
            let value = sample.quantity.doubleValue(for: self.heartRateUnit)
            self.mainLabel.setText(String(UInt16(value)))
            
            // retrieve source from sample
//            let name = sample.sourceRevision.source.name
//            self.updateDeviceName(name)
//            self.animateHeart()
        }
    }
    

}
