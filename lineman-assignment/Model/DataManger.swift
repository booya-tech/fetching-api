//
//  DataManger.swift
//  lineman-assignment
//
//  Created by Panachai Sulsaksakul on 4/17/23.
//

import Foundation

// MARK: - Protocol

protocol DataManagerDelegate {
    func didUpdateData(_ DataManger: DataManager, wongnai: WongnaiData)
    func didFailWithError(error: Error)
}

// MARK: - Fetching JSON data from API

struct DataManager {
    var delegate: DataManagerDelegate?
    
    func fetchData() {
        let urlString = K.wongnaiApi
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let sessionConfig = URLSessionConfiguration.default
            sessionConfig.timeoutIntervalForRequest = 3.0
            
            let session = URLSession(configuration: sessionConfig)
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let wongnaiData = self.parseJSON(safeData) {
                        self.delegate?.didUpdateData(self, wongnai: wongnaiData)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ wongnaiData: Data) -> WongnaiData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WongnaiData.self, from: wongnaiData)
            return decodedData
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
