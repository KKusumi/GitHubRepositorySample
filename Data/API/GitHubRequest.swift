//
//  GitHubRequest.swift
//  Data
//
//  Created by kusumi on 2021/06/13.
//

import Foundation
import APIKit

public protocol GitHubRequest: Request{}

public extension GitHubRequest {
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
}

extension GitHubRequest {
    public func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        switch urlResponse.statusCode {
        case 200..<300:
            return object
        default:
            throw NSError(domain: "Bad Status Response", code: urlResponse.statusCode, userInfo: nil)
        }
    }
}

struct DecodableDataParser: DataParser {
    let contentType: String? = "application/json"
    
    func parse(data: Data) throws -> Any {
        return data
    }
    
}

// protocol→Impl作る
// associatedtype：ジェネリクスと同じような感じ。準拠する側で型を指定する
// where：条件付きの拡張
extension GitHubRequest where Response: Decodable {
    public var dataParser: DataParser {
        return DecodableDataParser()
    }
    
    public func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        guard let data = object as? Data else {
            throw ResponseError.unexpectedObject(object)
        }
        return try JSONDecoder().decode(Response.self, from: data)
    }
}
