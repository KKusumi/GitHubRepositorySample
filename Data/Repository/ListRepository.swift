//
//  PokemonListRepository.swift
//  Data
//
//  Created by kusumi on 2021/07/13.
//

import Foundation
import Shared
import APIKit
import RxSwift

public enum ListRepositoryProvider {
    public static func provide() -> ListRepository {
        return ListRepositoryImpl()
    }
}

public protocol ListRepository {
    func get(language: String, page: Int) -> Observable<GitHubApi.SearchRequest.Response>
}

private struct ListRepositoryImpl: ListRepository {
    func get(language: String, page: Int) -> Observable<GitHubApi.SearchRequest.Response> {
        return Session.shared.rx.response(GitHubApi.SearchRequest(language: language, page: page))
    }
}
