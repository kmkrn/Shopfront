//
//  Agent.swift
//  Shopfront
//
//  Created by denpazakura on 27/08/2021.
//

import Foundation
import Combine
import os.log

struct Agent {
    private var baseFileURL: String
    private let logger = Logger(subsystem: "com.denpazakura.Shopfront", category: "api")
    
    init(fileURL: String) {
        baseFileURL = fileURL
    }
    
    func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: Bundle.main.url(forResource: baseFileURL, withExtension: "json")!)
            .map { $0.data }
            .handleEvents(receiveOutput: { logger.info("Parsed values: \(NSString(data: $0, encoding: String.Encoding.utf8.rawValue)!)")})
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
