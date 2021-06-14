//
//  GitHubRepository.swift
//  Data
//
//  Created by kusumi on 2021/06/13.
//

import Foundation

public struct GitHubRepository: Decodable {
    let id: Int
    let fullName: String
    let description: String
    let stargazersCount: Int
    let url: URL
    
    private enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name" // キャメルケースではパースできないので、スネークケースとして扱っている。
        case description
        case stargazersCount = "stargazers_count"
        case url = "html_url"
    }
}

struct SearchRepositoriesResponse: Decodable {
    let items: [GitHubRepository]
}
