//
//  ListViewModel.swift
//  Presentation
//
//  Created by kusumi on 2021/06/14.
//

import UIKit
import RxSwift
import APIKit
import Action
import Data

protocol ListViewModelInputs {
    var fetchTrigger: PublishSubject<Void> { get }
    var reachedBottomTrigger: PublishSubject<Void> { get }
}

protocol ListViewModelOutputs {
    var navigationBarTitle: Observable<String> { get }
    var gitHubRepositories: Observable<GitHubRepository> { get }
    var isLoading: Observable<Bool> { get }
    var error:Observable<NSError> { get }
}

protocol  ListViewModelType {
    var inputs: ListViewModelInputs { get }
    var outputs: ListViewModelOutputs { get }
}

final class ListViewModel: ListViewModelType, ListViewModelInputs, ListViewModelOutputs {
    
    var inputs: ListViewModelInputs { return self }
    var outputs: ListViewModelOutputs { return self }
    
    let fetchTrigger = PublishSubject<Void>()
    let reachedBottomTrigger = PublishSubject<Void>()
    private let page = BehaviorRelay<Int>(value: 1)
    
    let navigationBarTitle: Observable<String>
    let gitHubRepositories: Observable<[GitHubRepository]>
    let isLoading: Observable<Bool>
    let error: Observable<NSError>
    
    private let searchAction: Action<Int, [GitHubRepository]>
    private let disposeBag = DisposeBag()
    
    init(language: String) {
        self.navigationBarTitle = Observable.just("\(language) Repositories")
        self.searchAction = Action { page in
            return Session.shared.rx.response(GitHubApi.SearchRequest(language: language, page: page))
        }
    }
}
