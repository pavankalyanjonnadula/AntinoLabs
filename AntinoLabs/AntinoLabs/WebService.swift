//
//  WebService.swift
//  MovieFlix
//
//  Created by Pavan Kalyan Jonnadula on 17/05/20.
//  Copyright © 2020 Pavan Kalyan Jonnadula. All rights reserved.
//

import Foundation
public typealias HttpRequestCompletionBlock = (Data?, URLResponse?, Error?) -> Void

public class WebService : NSObject {
    static let shared = WebService()
    public func getRequest(urlString : String ,requestCompletion: HttpRequestCompletionBlock?) {
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error with fetching films: \(error)")
                return
            }
            if let jsonData = data{
                DispatchQueue.main.async {
                    requestCompletion!(jsonData, response, error)
                }
            }
        }
        task.resume()
    }
}
    
