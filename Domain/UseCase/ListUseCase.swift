//
//  ListUseCase.swift
//  Domain
//
//  Created by kusumi on 2021/07/13.
//

import Foundation
import RxSwift
import Data

public enum ListUseCaseProvider {
    public static func provide() -> ListUseCase {
        return ListUseCaseImpl(repository: ListRepositoryProvider.provide())
    }
}

public protocol ListUseCase {
    func get(language: String, page: Int) -> Observable<GitHubApi.SearchRequest.Response>
}

private struct ListUseCaseImpl: ListUseCase {
    let repository: ListRepository
    
    func get(language: String, page: Int) -> Observable<GitHubApi.SearchRequest.Response> {
        return repository.get(language: language, page: page)
    }
}
