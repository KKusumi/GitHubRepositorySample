//
//  GitHubApi.swift
//  Data
//
//  Created by kusumi on 2021/06/13.
//

import Foundation
import APIKit

public final class GitHubApi {}

public extension GitHubApi {
    
    struct SearchRequest: GitHubRequest {
        
        let language: String
        let page: Int
        
        public init(language: String = "Swift", page: Int) {
            self.language = language
            self.page = page
        }
        
        public let method: HTTPMethod = .get
        public let path: String = "/search/repositories"
        
        public var parameters: Any? {
            var params = [String: Any]()
            params["q"] = language
            params["sort"] = "stars"
            params["page"] = "\(page)"
            return params
        }
        
        public func response(from object: Any, urlResponse: HTTPURLResponse) throws -> [GitHubRepository] {
            guard let data = object as? Data else {
                throw ResponseError.unexpectedObject(object)
            }
            let res = try JSONDecoder().decode(SearchRepositoriesResponse.self, from: data)
            return res.items
        }
    }
    
}
