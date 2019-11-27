//
//  NetworkCallManagers.swift
//  ClapAnimation
//
//  Created by Khyati Mirani on 20/11/19.
//  Copyright © 2019 Khyati Mirani. All rights reserved.
//

import Foundation
import Network


typealias ErrorCompletion       = (Error?) -> Void

class NetworkCallManager{
    
   static let shared = NetworkCallManager()
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: Constants.monitorLabel)
    let cellMonitor = NWPathMonitor(requiredInterfaceType: .cellular)
    var isConnected : Bool?
    
    private init(){
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.isConnected = true
                print(Constants.connected)
            } else {
                self.isConnected = false
                print(Constants.notConnected)
            }
        }
    }
    
    
    func makeNetworkRequest(errorCompletion: @escaping ErrorCompletion){
        let session = URLSession.shared
        guard let url = URL(string: Constants.urlString) else {
            return
        }
        var  request = URLRequest(url: url)
        request.setValue(Constants.headerValue, forHTTPHeaderField: Constants.contentType )
        request.setValue(Constants.headerValue, forHTTPHeaderField: Constants.accept)
            let dataTask =  session.dataTask(with: request, completionHandler: { data, response, error in
                if error != nil {
                    errorCompletion(error)
                    print(Constants.networkCallFailed)
                 }
                else {
                    errorCompletion(nil)
                }
            })
            dataTask.resume()
    }
    
    
}
