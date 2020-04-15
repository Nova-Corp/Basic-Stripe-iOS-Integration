//
//  BackendAPIAdapter.swift
//  Basic Integration
//
//  Created by Ben Guo on 4/15/16.
//  Copyright © 2016 Stripe. All rights reserved.
//

import Foundation
import Stripe

class MyAPIClient: NSObject, STPCustomerEphemeralKeyProvider {
    enum APIError: Error {
        case unknown
        
        var localizedDescription: String {
            switch self {
            case .unknown:
                return "Unknown error"
            }
        }
    }

    static let sharedClient = MyAPIClient()
    var baseURLString: String? = nil
    var baseURL: URL {
        if let urlString = self.baseURLString, let url = URL(string: urlString) {
            return url
        } else {
            fatalError()
        }
    }
    
    func createPaymentIntent(products: [Product], shippingMethod: PKShippingMethod?, country: String? = nil, completion: @escaping ((Result<String, Error>) -> Void)) {
        let url = self.baseURL.appendingPathComponent("charge")
        var params: [String: Any] = [
            "metadata": [
                // example-ios-backend allows passing metadata through to Stripe
                "payment_request_id": "B3E611D1-5FA1-4410-9CEC-00958A5126CB",
            ],
            "currency": "USD",
            "amount": "1000",
            "payment_method_types": ["card"],
            "customer_id": "cus_GnCe40OufqnsOc",
            "description": "Software development services",
            "shipping": [
                "name": "Jenny Rosen",
                "address": [
                    "line1": "510 Townsend St",
                    "postal_code": "98140",
                    "city": "San Francisco",
                    "state": "CA",
                    "country": "US"
                ]
            ]
        ]
        params["products"] = products.map({ (p) -> String in
            return p.emoji
        })
//        if let shippingMethod = shippingMethod {
//            params["shipping"] = shippingMethod.identifier
//        }
        params["country"] = country
        let jsonData = try? JSONSerialization.data(withJSONObject: params)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiOWQ5ZTc4MzQzODIxYzM5NmViOWZmMjFmNTkzN2FiYzJjYmY0Y2Q5MDRlNDNhYmJiZGQwNDlkNjJiM2M3ODM4Y2Y1MTU4ZjA3YzYwODc4ZjEiLCJpYXQiOjE1ODU1MDIyNTAsIm5iZiI6MTU4NTUwMjI1MCwiZXhwIjoxNjE3MDM4MjUwLCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.uZmTLxOeChPt36uGLtLFySr93CzJkX_5QQb82S2VrtMNhsFUH5sqie_auVr8briK3U3i-hjXu7LqbNo5FNRXcFfeYkFi0aNtMLZOlpYL1TYk1PhbIVvEaVLpukpz2NAIbJjhy3dwFefkddCot2Mx2QNWbkhGqbQMbmanqxEo1nE-QaXaYVm8UgPgLDYfJd9MkQ-SWuMU5weBDGtfWJHLsyYnfxTacLcfukCN5cSYx3SihlK2DleEBtpCsA8_RC0fOEjdKqCyZgRQUlRYE1lEQtL4Y7t22PsNMIcS0OajJOS0vow9uAYmW0vbRCXdYdR89F6gtmWqou1FeKfOBH4U9A3rmH5JzeWqMbpAz_y3LnXueI5EgsOzuc5V88cHn1VnsSO5Yc50DoBBAKbXlFsqbsc1RcAikrLPHwe0PHrleGUBfgqbny0NIH34A6qVujbJWhytmyGLo3yyXgfyUn3vWLgIZJwtp3MeBXnZ4YzeWgh93i_qAuBo0tCmIQTn-QWiqy22-YOXxtWp_p_IX7GN4Dbg3r0riJX5Gn8XlKcHZfOYasSUqzVvYnGlHXrDOA6gsb9VFeRdEyfsKvrnwus-a_giQv7LjltpRwM4Yi16HXxUsnMvI5F3sQt1F22wlZ-sg1XOozw04MWDk1VbI0tew3XS53qt7FPSPkVNItbJ9uw", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            print(String(data: data!, encoding: .utf8))
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data = data,
                let json = ((try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]) as [String : Any]??),
                let secret = json?["client_secret"] as? String else {
                    completion(.failure(error ?? APIError.unknown))
                    return
            }
            completion(.success(secret))
        })
        task.resume()
    }

    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        var url = self.baseURL.appendingPathComponent("ephemeral_keys")
//        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        url.appendPathComponent("customer_id=cus_GnCe40OufqnsOc&api_version=\(apiVersion)")
        var request = URLRequest(url: url)
//        print(url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiOWQ5ZTc4MzQzODIxYzM5NmViOWZmMjFmNTkzN2FiYzJjYmY0Y2Q5MDRlNDNhYmJiZGQwNDlkNjJiM2M3ODM4Y2Y1MTU4ZjA3YzYwODc4ZjEiLCJpYXQiOjE1ODU1MDIyNTAsIm5iZiI6MTU4NTUwMjI1MCwiZXhwIjoxNjE3MDM4MjUwLCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.uZmTLxOeChPt36uGLtLFySr93CzJkX_5QQb82S2VrtMNhsFUH5sqie_auVr8briK3U3i-hjXu7LqbNo5FNRXcFfeYkFi0aNtMLZOlpYL1TYk1PhbIVvEaVLpukpz2NAIbJjhy3dwFefkddCot2Mx2QNWbkhGqbQMbmanqxEo1nE-QaXaYVm8UgPgLDYfJd9MkQ-SWuMU5weBDGtfWJHLsyYnfxTacLcfukCN5cSYx3SihlK2DleEBtpCsA8_RC0fOEjdKqCyZgRQUlRYE1lEQtL4Y7t22PsNMIcS0OajJOS0vow9uAYmW0vbRCXdYdR89F6gtmWqou1FeKfOBH4U9A3rmH5JzeWqMbpAz_y3LnXueI5EgsOzuc5V88cHn1VnsSO5Yc50DoBBAKbXlFsqbsc1RcAikrLPHwe0PHrleGUBfgqbny0NIH34A6qVujbJWhytmyGLo3yyXgfyUn3vWLgIZJwtp3MeBXnZ4YzeWgh93i_qAuBo0tCmIQTn-QWiqy22-YOXxtWp_p_IX7GN4Dbg3r0riJX5Gn8XlKcHZfOYasSUqzVvYnGlHXrDOA6gsb9VFeRdEyfsKvrnwus-a_giQv7LjltpRwM4Yi16HXxUsnMvI5F3sQt1F22wlZ-sg1XOozw04MWDk1VbI0tew3XS53qt7FPSPkVNItbJ9uw", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data = data,
                let json = ((try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]) as [String : Any]??) else {
                completion(nil, error)
                return
            }
            completion(json, nil)
        })
        task.resume()
    }

}
