//
//  Network.swift
//  TMDb
//
//  Created by Lucas Santos on 30/03/19.
//  Copyright © 2019 Lucas Santos. All rights reserved.
//

import Keys

enum API {
    static let baseURL = "https://api.themoviedb.org/3/"
    static let imageBaseURL = "https://image.tmdb.org/t/p/"
    static let keyQueryString = "api_key="
}

enum Operation: String {
    case get = "GET"
    case update = "PUT"
    case delete = "DELETE"
    case create = "POST"
}

//Response struct with generic type
struct Response<Element: Decodable>: Decodable {
    let results: [Element]
    let page: Int
    let totalPages: Int
}

import Foundation

class NetworkManager {

    // MARK: - Properties
    static let configuration: URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Content-Type": "application/json"]
        configuration.timeoutIntervalForResource = 15.0
        return configuration
    }()
    static let session = URLSession(configuration: configuration)

    // MARK: - Methods
    class func getWithPagination<Element: Decodable>(_ path: String,
                                                     type: Element.Type,
                                                     onComplete: @escaping ([Element], Int, Int) -> Void,
                                                     onError: @escaping (Error?) -> Void) {
        let keys = TMDbKeys()
        guard let url = URL(string: API.baseURL + path + API.keyQueryString + keys.tMDb_api_key) else {
            return onError(nil)
        }
        var request = URLRequest(url: url)
        request.httpMethod = Operation.get.rawValue
        let task = session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let decodedResponse = try decoder.decode(Response<Element>.self, from: data)
                    onComplete(decodedResponse.results, decodedResponse.page, decodedResponse.totalPages)
                } catch {
                    return onError(nil)
                }
            } else if response != nil {
                return onError(error)
            }
        }
        task.resume()
    }

    class func get<Element: Decodable>(_ path: String,
                                       type: Element.Type,
                                       onComplete: @escaping (Element) -> Void,
                                       onError: @escaping (Error?) -> Void) {
        let keys = TMDbKeys()
        guard let url = URL(string: API.baseURL + path + API.keyQueryString + keys.tMDb_api_key) else {
            return onError(nil)
        }
        var request = URLRequest(url: url)
        request.httpMethod = Operation.get.rawValue
        let task = session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let decodedResponse = try decoder.decode(Element.self, from: data)
                    onComplete(decodedResponse)
                } catch {
                    return onError(nil)
                }
            } else if response != nil {
                return onError(error)
            }
        }
        task.resume()
    }

}
