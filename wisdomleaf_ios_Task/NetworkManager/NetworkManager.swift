//
//  NetworkManager.swift
//  wisdomleaf_ios_Task
//
//  Created by dattaz biradar on 12/09/24.
//

import Foundation

enum NetworkError : Error {
    case badUrl
       case noData
       case badResponse(Int)
       case decodingError
       case unknownError
       
       // Custom descriptions for each error type (optional)
       var localizedDescription: String {
           switch self {
           case .badUrl:
               return "The URL provided was invalid."
           case .noData:
               return "No data was received from the server."
           case .badResponse(let statusCode):
               return "Received a bad response from the server. Status code: \(statusCode)."
           case .decodingError:
               return "Failed to decode the response data."
           case .unknownError:
               return "An unknown error occurred."
           }
       }
}

protocol NetworkRequestProtocol {
    func fetchRequest<T:Codable>(_ url : String, type : T.Type, handler : @escaping(Result<T,Error>) -> ())
}


class HttpClient : NetworkRequestProtocol {
    func fetchRequest<T:Codable>(_ url: String, type: T.Type, handler: @escaping (Result<T, Error>) -> ()){
        
        guard let url = URL(string: url) else {
            handler(.failure(NetworkError.badUrl))
            return
        }
        
        let request = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                handler(.failure(error))
                return
            }
            
            // Ensure data and response are non-nil
            guard let data = data, let httpResponse = response as? HTTPURLResponse else {
                handler(.failure(NetworkError.noData))
                return
            }
            
            // Ensure the response is within the valid 2xx range
            guard (200...299).contains(httpResponse.statusCode) else {
                handler(.failure(NetworkError.badResponse(httpResponse.statusCode)))
                return
            }
            
            // Decode the response data
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                handler(.success(decodedData))
            } catch {
                handler(.failure(NetworkError.decodingError))
            }
        }
        
        // Start the data task
        dataTask.resume()
    }
    
}

// Box Technique for data binding
class Observable<T> {

    var value: T {
        didSet {
            listener?(value)
        }
    }

    private var listener: ((T) -> Void)?

    init(_ value: T) {
        self.value = value
    }

    func bind(_ closure: @escaping (T) -> Void) {
        closure(value)
        listener = closure
    }
}
