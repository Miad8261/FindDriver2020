//
//  AddNewVehicle.swift
//  FindDriver
//
//  Created by Miad Azarmehr on 2019-04-01.
//  Copyright © 2019 Miad Azarmehr. All rights reserved.
//

import Foundation
import Firebase

class ShowAddOwnerVehicle: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentLoggedInOwner = Auth.auth().currentUser!.uid
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "MessageCell", bundle: nil) , forCellReuseIdentifier: "customMessageCell")
        
        configureTableView()
        retrieveVehicles()
        retrievePayments()
    }
    
    
    @IBAction func logOutButton(_ sender: UIBarButtonItem) {
        do{
            try Auth.auth().signOut()
        } catch let logoutError {
            print (logoutError)
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sigInVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        self.present(sigInVC, animated: true, completion: nil)
        driverInstance = Driver()
        vehicleArray = [Vehicle]()
        requestedVehiclesArray = [Vehicle]()
        paymentArray = [Payment]()
        ownersArray = [Owner]()
        vehicleIndex = 0
        requestedIndex = 0
        paymentIndex = 0
        ownerIndex = 0
    }
    
    func configureTableView() {
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var vehicleAvailiblity = ""
        if vehicleArray[indexPath.row].availability == true {
            vehicleAvailiblity = "Not Rented"
        }
        else
        {
            vehicleAvailiblity = "Rented"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        cell.vehicleDetailLabel.text = "\(vehicleArray[indexPath.row].type) \(vehicleArray[indexPath.row].brand) \(vehicleArray[indexPath.row].model) \(vehicleArray[indexPath.row].year) $\(vehicleArray[indexPath.row].weeklyRent) \(vehicleAvailiblity) "
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print ("vehiclecount vehicleArray ============ \(vehicleArray.count)")
        return vehicleArray.count
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        vehicleIndex = indexPath.row
        performSegue(withIdentifier: "editOwnerVehicle", sender: self)
    }
    
    
    @IBAction func unwindToShowOwnerVehicles(_ unwindSegue: UIStoryboardSegue) {
        
    }
    
    
    func retrieveVehicles() {
        
        let ref = Database.database().reference().child("vehicles")
        let query = ref.queryOrdered(byChild: "ownerID").queryEqual(toValue: currentLoggedInOwner)
        query.observe(.childAdded) { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any] {
                
                let vehicleAutoGeneratedKey = snapshot.key
                let allVehicles = Vehicle()
                
                let availability = dictionary["availability"] as? Bool
                let brand = dictionary["brand"] as? String
                let model = dictionary["model"] as? String
                let ownerID = dictionary["ownerID"] as? String
                let type = dictionary["type"] as? String
                let weeklyRent = dictionary["weeklyRent"] as? String
                let year = dictionary["year"] as? String
                let driverPhone = dictionary["driverPhone"] as? String
                let driverID = dictionary["driverID"] as? String
                let driverName = dictionary["driverName"] as? String
                let vehicleRequested = dictionary["vehicleRequested"] as? Bool
                let requestAccepted = dictionary["requestAccepted"] as? Bool
                let driverAutoGeneratedKey = dictionary["driverAutoGeneratedKey"] as? String
                
                allVehicles.availability = availability ?? true
                allVehicles.brand = brand ?? ""
                allVehicles.model = model ?? ""
                allVehicles.ownerID = ownerID ?? ""
                allVehicles.type = type ?? ""
                allVehicles.weeklyRent = weeklyRent ?? ""
                allVehicles.year = year ?? ""
                allVehicles.driverPhone = driverPhone ?? ""
                allVehicles.driverID = driverID ?? ""
                allVehicles.driverName = driverName ?? ""
                allVehicles.vehicleRequested = vehicleRequested ?? false
                allVehicles.requestAccepted = requestAccepted ?? false
                allVehicles.vehicleAutoGeneratedKey = vehicleAutoGeneratedKey
                allVehicles.driverAutoGeneratedKey = driverAutoGeneratedKey ?? ""
                
                vehicleArray.append(allVehicles)
                
                if vehicleRequested == true  && requestAccepted == false {
                    requestedVehiclesArray.append(allVehicles)
                }

                self.configureTableView()
                self.tableView.reloadData()
            }
        }
    }
    
    
//    func retrieveVehicles() {
//
//        let currentLoggedInUserID = Auth.auth().currentUser?.uid
//        let ref = Database.database().reference().child("vehicles")
//        let query = ref.queryOrdered(byChild: "ownerID").queryEqual(toValue: currentLoggedInUserID)
//        query.observe(.value, with: { (snapshot) in
//
//            for snaps in snapshot.children.allObjects as! [DataSnapshot] {
//
//                let vehiclesRetrived = snaps.value!
//                print("Here in ShowAddOwnerVehicle2 \(vehiclesRetrived)")
//                let dictionary = snaps.value as? NSDictionary
//
//                let vehicleAutoGeneratedKey = snaps.key
//                let allVehicles = Vehicle()
//
//                let availability = dictionary?["availability"] as? Bool
//                let brand = dictionary?["brand"] as? String
//                let model = dictionary?["model"] as? String
//                let ownerID = dictionary?["ownerID"] as? String
//                let type = dictionary?["type"] as? String
//                let weeklyRent = dictionary?["weeklyRent"] as? String
//                let year = dictionary?["year"] as? String
//                let driverPhone = dictionary?["driverPhone"] as? String
//                let driverID = dictionary?["driverID"] as? String
//                let driverName = dictionary?["driverName"] as? String
//                let vehicleRequested = dictionary?["vehicleRequested"] as? Bool
//                let requestAccepted = dictionary?["requestAccepted"] as? Bool
//                let driverAutoGeneratedKey = dictionary?["driverAutoGeneratedKey"] as? String
//                //                let vehicleAutoGenerateKey = dictionary?["vehicleAutoGenerateKey"] as? String
//
//
//                allVehicles.availability = availability ?? true
//                allVehicles.brand = brand ?? ""
//                allVehicles.model = model ?? ""
//                allVehicles.ownerID = ownerID ?? ""
//                allVehicles.type = type ?? ""
//                allVehicles.weeklyRent = weeklyRent ?? ""
//                allVehicles.year = year ?? ""
//                allVehicles.driverPhone = driverPhone ?? ""
//                allVehicles.driverID = driverID ?? ""
//                allVehicles.driverName = driverName ?? ""
//                allVehicles.vehicleRequested = vehicleRequested ?? false
//                allVehicles.requestAccepted = requestAccepted ?? false
//                //                theVehicles.vehicleAutoGenerateKey = vehicleAutoGenerateKey ?? ""
//                allVehicles.vehicleAutoGeneratedKey = vehicleAutoGeneratedKey
//                allVehicles.driverAutoGeneratedKey = driverAutoGeneratedKey ?? ""
//
//                vehicleArray.append(allVehicles)
//
//                //                if vehicleRequested == true {
//                //                    requestedVehiclesArray.append(allVehicles)
//                //                }
//
//                self.configureTableView()
//
//            }
//        })
//    }
    
        func retrievePayments() {
    
            let currentLoggedInUserID = Auth.auth().currentUser?.uid
            let ref = Database.database().reference().child("payments")
            let query = ref.queryOrdered(byChild: "ownerID").queryEqual(toValue: currentLoggedInUserID)
            query.observe(.value, with: { (snapshot) in
    
                for snaps in snapshot.children.allObjects as! [DataSnapshot] {
    
                    let paymentAutoGeneratedKey = snaps.key
                    let paymentsRetrived = snaps.value!
                    print("Here in PAYMENTS \(paymentsRetrived)")
    
                    let dictionary = snaps.value as? NSDictionary
                    let allPayments = Payment()
    
                    let amount = dictionary?["amount"] as? String
                    let driverAutoGenerateKey = dictionary?["driverAutoGenerateKey"] as? String
                    let driverID = dictionary?["driverID"] as? String
                    let endDate = dictionary?["endDate"] as? String
                    let ownerID = dictionary?["ownerID"] as? String
                    let paymentConfirmed = dictionary?["paymentConfirmed"] as? Bool
                    let startDate = dictionary?["startDate"] as? String
                    let vehicleAutoGeneratedKey = dictionary?["vehicleAutoGeneratedKey"] as? String
                    let driverMessage = dictionary?["driverMessage"] as? String
                    
    
                    allPayments.amount = amount ?? ""
                    allPayments.driverAutoGenerateKey = driverAutoGenerateKey ?? ""
                    allPayments.driverID = driverID ?? ""
                    allPayments.endDate = endDate ?? ""
                    allPayments.ownerID = ownerID ?? ""
                    allPayments.paymentConfirmed = paymentConfirmed ?? false
                    allPayments.startDate = startDate ?? ""
                    allPayments.vehicleAutoGeneratedKey = vehicleAutoGeneratedKey ?? ""
                    allPayments.driverMessage = driverMessage ?? ""
                    allPayments.paymentAutoGeneratedKey = paymentAutoGeneratedKey
    
                    paymentArray.append(allPayments)
                    self.configureTableView()
                }
            })
        }
}

