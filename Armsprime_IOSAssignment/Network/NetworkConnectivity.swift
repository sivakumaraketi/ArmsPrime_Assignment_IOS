//
//  NetworkConnectivity.swift
//  Armsprime_IOSAssignment
//
//  Created by Siva Kumar Aketi on 29/01/20.
//  Copyright © 2020 SivaKumarAketi. All rights reserved.
//

import Foundation
import Alamofire

let reachabilityManager = NetworkReachabilityManager()
// this class is responsible for network handling
class NetworkConnectivity {
   
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
