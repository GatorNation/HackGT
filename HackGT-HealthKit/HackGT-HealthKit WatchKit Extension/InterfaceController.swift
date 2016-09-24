//
//  InterfaceController.swift
//  HackGT-HealthKit WatchKit Extension
//
//  Created by David  Yeung on 9/24/16.
//  Copyright © 2016 David  Yeung. All rights reserved.
//

import WatchKit
import Foundation
import HealthKit


class InterfaceController: WKInterfaceController, HKWorkoutSessionDelegate {

    //Variables
    @IBOutlet var startButton: WKInterfaceButton!
    @IBOutlet var heartRateLabel: WKInterfaceLabel!
    let healthStore = HKHealthStore()
    var currenQuery : HKQuery?
    let heartRateUnit = HKUnit(from: "count/min")
    var session : HKWorkoutSession?

    
    ///standard functions
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        self.registerHealthKit()
        self.checkHealthKit()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    //Register healthkit
    func registerHealthKit()
    {
//        if (HKHealthStore.isHealthDataAvailable())
//        {
//            self.healthStore.requestAuthorization(toShare: nil, read: self.dataTypesToRead() as? Set<HKObjectType>, completion: { (success, error) in
//                if (!success)
//                {
//                    print(error)
//                }
//                else
//                {
//                    print("Request granted!")
//                }
//            })
//        }
    }
    
    func dataTypesToRead() -> NSSet
    {
        let heartRate = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)
        return NSSet.init(objects:heartRate)
    }
    
    //Hkhealthstore queries 
    func checkHealthKit()
    {
        guard HKHealthStore.isHealthDataAvailable() == true else {
            heartRateLabel.setText("not available")
            return
        }
        
        guard let quantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate) else {
            heartRateLabel.setText("not allowed")
            return
        }
        
        let dataTypes = Set(arrayLiteral: quantityType)
        healthStore.requestAuthorization(toShare: nil, read: dataTypes) { (success, error) -> Void in
            if success == false {
                self.heartRateLabel.setText("not allowed")
            }
        }
    }
    func createHeartRateStreamingQuery(_ workoutStartDate: Date) -> HKQuery? {
        
        
        guard let quantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate) else { return nil }
        let datePredicate = HKQuery.predicateForSamples(withStart: workoutStartDate, end: nil, options: .strictEndDate )
        //let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates:[datePredicate])
        
        
        let heartRateQuery = HKAnchoredObjectQuery(type: quantityType, predicate: predicate, anchor: nil, limit: Int(HKObjectQueryNoLimit)) { (query, sampleObjects, deletedObjects, newAnchor, error) -> Void in
            //guard let newAnchor = newAnchor else {return}
            //self.anchor = newAnchor
            self.updateHeartRate(sampleObjects)
        }
        
        heartRateQuery.updateHandler = {(query, samples, deleteObjects, newAnchor, error) -> Void in
            //self.anchor = newAnchor!
            self.updateHeartRate(samples)
        }
        return heartRateQuery
    }
    
    func updateHeartRate(_ samples: [HKSample]?) {
        guard let heartRateSamples = samples as? [HKQuantitySample] else {
            print("samples is unavailable")
            return
        }
        
        guard let sample = heartRateSamples.first else{
            print("first heart rate sample is unavailable")
            return
        }
        let value = sample.quantity.doubleValue(for: self.heartRateUnit)
        self.heartRateLabel.setText(String(UInt16(value)))
        
//        DispatchQueue.main.async {
//            guard let sample = heartRateSamples.first else{return}
//            let value = sample.quantity.doubleValue(for: self.heartRateUnit)
//            self.heartRateLabel.setText(String(UInt16(value)))
//            
////            // retrieve source from sample
////            let name = sample.sourceRevision.source.name
////            self.updateDeviceName(name)
////            self.animateHeart()
//        }
    }
    
    @IBAction func startBtnPressed() {
        // If we have already started the workout, then do nothing.
        if (session != nil) {
            return
        }
        
        // Configure the workout session.
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .crossTraining
        workoutConfiguration.locationType = .indoor
        
        do {
            session = try HKWorkoutSession(configuration: workoutConfiguration)
            session?.delegate = self
        } catch {
            fatalError("Unable to create the workout session!")
        }
        healthStore.start(self.session!)
    }
    
    
    //Workout session delegate methods
    
    func workoutSession(_ workoutSession:HKWorkoutSession, didChangeTo toState:HKWorkoutSessionState, from prevState:HKWorkoutSessionState, date: Date)
    {
        if toState == .running
        {
            workoutDidStart(date)
        }
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError: Error)
    {
        print("Workout session failed: \(didFailWithError)")
    }
    
    func workoutSession(_workoutSession : HKWorkoutSession, didGenerate: HKWorkoutEvent)
    {
        print("Generated workout: \(didGenerate)")
    }
    
    
    func workoutDidStart(_ date : Date) {
        if let query = createHeartRateStreamingQuery(date) {
            self.currenQuery = query
            healthStore.execute(query)
        } else {
            heartRateLabel.setText("cannot start")
        }
    }
}
