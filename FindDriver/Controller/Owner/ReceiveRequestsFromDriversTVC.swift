//
//  ReceiveRequestsFromDriversTVC.swift
//  FindDriver
//
//  Created by Miad Azarmehr on 2019-04-06.
//  Copyright © 2019 Miad Azarmehr. All rights reserved.
//

import UIKit
import Firebase

class ReceiveRequestsFromDriversTVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ref = Database.database().reference()

        tableView.register(UINib(nibName: "MessageCell", bundle: nil) , forCellReuseIdentifier: "customMessageCell")
        
        configureTableView()
        
    }
    
    func configureTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120.0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        requestedIndex = indexPath.row
        if vehicleArray[indexPath.row].vehicleRequested == true {
        cell.vehicleDetailLabel.text = "\(vehicleArray[indexPath.row].type) \(vehicleArray[indexPath.row].brand) \(vehicleArray[indexPath.row].model) \(vehicleArray[indexPath.row].year) \(vehicleArray[indexPath.row].weeklyRent) \(vehicleArray[indexPath.row].vehicleAutoGenerateKey)"
        }

//        cell.vehicleDetailLabel.text = "\(requestedVehiclesArray[indexPath.row].type) \(requestedVehiclesArray[indexPath.row].brand) \(requestedVehiclesArray[indexPath.row].model) \(requestedVehiclesArray[indexPath.row].year) \(requestedVehiclesArray[indexPath.row].weeklyRent)"
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print ("vehiclecount============ \(vehicleArray.count)")
        return vehicleArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        vehicleIndex = indexPath.row
        performSegue(withIdentifier: "goToReceivedRequests", sender: self)
    }
    
    
    @IBAction func unwindToOwnerReceivedRequests(_ unwindSegue: UIStoryboardSegue) {
    }
    
}