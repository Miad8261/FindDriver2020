//
//  VehicleRentSendRequestTVC.swift
//  FindDriver
//
//  Created by mobileapps on 2019-04-05.
//  Copyright © 2019 Miad Azarmehr. All rights reserved.
//

import UIKit
import Firebase

class DriverSendVehicleRentSendRequestTVC: UITableViewController {
    

    
    @IBOutlet weak var vehicleDetails: UITextView!
    @IBOutlet weak var requestStatus: UILabel!
    
    var ref: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

        var requestAccepted = ""
        if vehicleArray[vehicleIndex].requestAccepted == true {
            requestAccepted = "Request Accepted"
        }
        else {
            requestAccepted = "Request Pending!"
        }

        vehicleDetails.text = "\(vehicleArray[vehicleIndex].type)  \(vehicleArray[vehicleIndex].brand)  \(vehicleArray[vehicleIndex].model)  \(vehicleArray[vehicleIndex].year)   $\(vehicleArray[vehicleIndex].weeklyRent)  \(requestAccepted)  \(vehicleArray[vehicleIndex].ownerID)"
        
    }
    

    @IBAction func sendConnectionRequestToOwner(_ sender: UIBarButtonItem) {
        
        requestStatus.text = "Request pending!"
        
        let vehicleAutoGeneratedKey = vehicleArray[vehicleIndex].vehicleAutoGeneratedKey
        
        print( "documentAutoGeneratedKey = retreiveVehicleDetails.vehicleAutoGenerateKey \(vehicleGeneratedKey)")
        
        let vehicleIndexPathInFirebase = ref?.child("vehicles").child(vehicleAutoGeneratedKey)
        
        let dictionaryValue = ["vehicleRequested": true, "driverID": driverInstance.driverID, "driverPhone": driverInstance.phone, "driverName": "\(driverInstance.firstName)  \(driverInstance.lastName)", "driverAutoGeneratedKey": driverInstance.driverAutoGenerateKey] as [String : Any]
        
        vehicleIndexPathInFirebase?.updateChildValues(dictionaryValue, withCompletionBlock: { (error, ref) in
            if error != nil {
                print(error!)
            }
            print("Rent Rquest Sent To Owner's Vehicle \(vehicleGeneratedKey)")
           // self.dismiss(animated: false, completion: nil)
        })
    }
    
    
    @IBAction func disconnect(_ sender: UIButton) {
        
        let vehicleAutoGeneratedKey = vehicleArray[vehicleIndex].vehicleAutoGeneratedKey
        
        let vehicleIndexPathInFirebase = ref?.child("vehicles").child(vehicleAutoGeneratedKey)
        
        let dictionaryValue = ["vehicleRequested": false, "driverID": "", "driverPhone": "", "driverName": "" ,"requestAccepted": false, "availability": true, "driverAutoGeneratedKey": "", "connectedToDriver": ""] as [String : Any]
        
        vehicleIndexPathInFirebase?.updateChildValues(dictionaryValue, withCompletionBlock: { (error, ref) in
            if error != nil {
                print(error!)
            }
            print("Rent Rquest Sent To Owner's Vehicle \(vehicleAutoGeneratedKey)")
        })
        
        
        let driverAutoGeneratedKey = driverInstance.driverAutoGenerateKey
        let driverIndexPathInFirebase = ref?.child("profiles").child(driverAutoGeneratedKey)
        
        let dictionaryValue2 = ["vehicleAutoGeneratedKey": "", "connectedToAnyVehicles": false, "ownerID": ""] as [String : Any]
        
        driverIndexPathInFirebase?.updateChildValues(dictionaryValue2, withCompletionBlock: { (error, ref) in
            if error != nil {
                print(error!)
            }
            print("vehicle auto generated key removed from driver's profile! \(vehicleAutoGeneratedKey)")
        })
//        dismiss(animated: true, completion: nil)
    }
}
