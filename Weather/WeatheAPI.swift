//
//  WeatheAPI.swift
//  Weather
//
//  Created by Petro Golishevskiy on 10.05.2023.
//

import Foundation

enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case invalidData
    case noData
}


class WeatherAPI {
    static let shared = WeatherAPI()

    func performRequest<T: Decodable>(url: URL,
                                      method: HTTPMethod = .get,
                                      bodyParams: [String: Any]? = nil,
                                      queryParams: [String: Any]? = nil,
                                      headerParams: [String: String]? = nil,
                                      responseType: T.Type,
                                      requestHandler: (() -> Void)? = nil,
                                      completion: @escaping (T?, Error?) -> Void) {
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        if let queryParams = queryParams {
            urlComponents?.queryItems = queryParams.map { key, value in
                URLQueryItem(name: key, value: "\(value)")
            }
        }
        
        guard let requestUrl = urlComponents?.url else {
            completion(nil, NSError(domain: "", code: 400, userInfo: ["error": "Invalid URL"]))
            return
        }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = method.rawValue
        
        if let bodyParams = bodyParams {
            request.httpBody = try? JSONSerialization.data(withJSONObject: bodyParams, options: [])
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        if let headerParams = headerParams {
            for (key, value) in headerParams {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                completion(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let responseObject = try decoder.decode(T.self, from: data)
                completion(responseObject, nil)
            } catch let error {
                completion(nil, error)
            }
            if let requestHandler = requestHandler {
                requestHandler()
            }
        }
        
        task.resume()
    }
}
