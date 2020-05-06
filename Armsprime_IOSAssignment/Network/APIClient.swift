//
//  APIClient.swift
//  Armsprime_IOSAssignment
//
//  Created by Amsys on 30/01/20.
//  Copyright © 2020 SivaKumarAketi. All rights reserved.
//

import Foundation
import Alamofire

// this class is responsible for api fetches handling
class APIClient {
    
    private init() {}
       static let shared = APIClient()
    
    typealias completionBlock = (_ response: DataResponse<Any>?) -> Void
    
    static func newsPaper(language:String,page:Int, completion:@escaping completionBlock) {
        let url = commonurl + "&language=" + language + "&pageSize=10" + "&page=\(page)"
        //  print("url:\(url)")
        AF.request(url,method: .get, encoding : URLEncoding.default).responseJSON { (sessionData) in
            completion(sessionData)
           
        }
    }
}
