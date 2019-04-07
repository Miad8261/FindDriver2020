//
//  Driver.swift
//  FindDriver
//
//  Created by Miad Azarmehr on 2019-04-01.
//  Copyright © 2019 Miad Azarmehr. All rights reserved.
//

import Foundation
import Firebase

var driverInstance = Driver()

class Driver {
    
    var firstName = ""
    var lastName = ""
    var email = ""
    var password = ""
    var phone = ""
    var city = ""
    var postalCode = ""
    var availability = false
    var vehicleID = ""
    var driverID = ""
    var personID = ""
    var driverAutoGenerateKey = ""
    var requestSentStatus = false
}
