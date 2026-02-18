//
//  BusService.swift
//  DubBus
//
//


import Foundation

class BusService {
    
    func fetchBuses(completion: @escaping ([Bus]) -> Void) {
        
        guard let url = URL(string: "https://api.yourtransitagency.com/buses") else {
            completion([])
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data else {
                completion([])
                return
            }
            
            // Decode here
            // For now returning empty
            completion([])
            
        }.resume()
    }
}
