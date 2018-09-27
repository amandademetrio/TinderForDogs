//
//  TinderDogModel.swift
//  TinderForDogs2
//
//  Created by Amanda Demetrio on 9/27/18.
//  Copyright © 2018 Amanda Demetrio. All rights reserved.
//

import Foundation

class TinderDogModel {
    
    static func getAllDogs(completionHandler:@escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        let url = URL(string: "http://13.57.253.40/dogs")
        let session = URLSession.shared
        let task = session.dataTask(with: url!, completionHandler: completionHandler)
        task.resume()
    }
    
}
