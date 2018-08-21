//
//  NetworkService.swift
//  HowMuch
//
//  Created by Svetlana T on 17.08.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import Foundation

final class NetworkService {
    typealias DataTaskHandler = ((Any) -> Void)?
    private let defaultSession = URLSession(configuration: .default)
    private let cbrUrlString = "https://www.cbr-xml-daily.ru/daily_json.js"
    
    func currencyExchangeRate(completion: DataTaskHandler) {
        guard let cbrUrl = URL(string: cbrUrlString) else { return }
        
        let dataTask = defaultSession.dataTask(with: cbrUrl) { data, response, error in
            if let error = error {
                self.handleClientError(error)
                return
            }
            
            guard
                let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode)
            else {
                    self.handleServerError(response)
                    return
            }
            
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                completion?(json)
            } catch {
                print(error)
            }
        }
        dataTask.resume()
    }
    
    private func handleClientError(_ error: Error) {
        print("client error: \(error.localizedDescription)")
    }
    
    private func handleServerError(_ response: URLResponse?) {
        guard let response = response else { return }
        print("server error: \(response.description)")
    }
}
