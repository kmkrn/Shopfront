//
//  FruitAPI.swift
//  Shopfront
//
//  Created by denpazakura on 27/08/2021.
//

import Foundation
import Combine

enum FruitshopAPI {    
    private static let base = URL(string: "unsplash.json")!
    private static let agent = Agent(fileURL: "unsplash")
    
    static func trending() -> AnyPublisher<[UnsplashImage], Error> {
        let request = URLComponents(url: base, resolvingAgainstBaseURL: true)?
            .request
        return agent.run(request!)
    }
}

private extension URLComponents {
    var request: URLRequest? {
        url.map { URLRequest(url: $0) }
    }
}
