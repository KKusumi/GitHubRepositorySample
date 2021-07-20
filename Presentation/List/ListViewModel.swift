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
import Shared
import RxRelay
import Domain

// ViewController　-> ViewModel
// ユーザーからのイベントなのでPublishSubject
protocol ListViewModelInputs {
    var fetchTrigger: PublishSubject<Void> { get }
    var reachedBottomTrigger: PublishSubject<Void> { get }
}

// ViewModel -> ViewController
// データの状態なのでObservable
protocol ListViewModelOutputs {
    var navigationBarTitle: Observable<String> { get }
    var gitHubRepositories: Observable<[GitHubRepository]> { get }
    var isLoading: Observable<Bool> { get }
    var error:Observable<NSError> { get }
}

// ViewController側でListViewModelTypeとして持つことで、余計なプロパティにアクセスできないよう制限できる
protocol  ListViewModelType {
    var inputs: ListViewModelInputs { get }
    var outputs: ListViewModelOutputs { get }
}

public final class ListViewModel: ListViewModelType, ListViewModelInputs, ListViewModelOutputs {
    
    var inputs: ListViewModelInputs { return self }
    var outputs: ListViewModelOutputs { return self }
    
    // Input
    let fetchTrigger = PublishSubject<Void>()
    let reachedBottomTrigger = PublishSubject<Void>()
    
    // Output
    let navigationBarTitle: Observable<String>
    let gitHubRepositories: Observable<[GitHubRepository]>
    let isLoading: Observable<Bool>
    let error: Observable<NSError>
    
    private let listUseCase: ListUseCase
    private let page = BehaviorRelay<Int>(value: 1)
    private let searchAction: Action<Int, [GitHubRepository]>
    private let disposeBag = DisposeBag()
    
    public init(language: String, listUseCase: ListUseCase) {
        self.listUseCase = listUseCase
        self.navigationBarTitle = Observable.just("\(language) Repositories")
        self.searchAction = Action { page in
            return listUseCase.get(language: language, page: page)
        }
        let response = BehaviorRelay<[GitHubRepository]>(value: [])
        self.gitHubRepositories = response.asObservable()
        
        self.isLoading = searchAction.executing.startWith(false)
        self.error = searchAction.errors.map { _ in NSError(domain: "Network Error", code: 0, userInfo: nil) }
        
        searchAction.elements // elementsは成功が流れてくる
            .withLatestFrom(response) { ($0, $1) }
            .map { $0.1 + $0.0 }
            .bind(to: response)
            .disposed(by: disposeBag)
        
        searchAction.elements
            .withLatestFrom(page)
            .map { $0 + 1}
            .bind(to: page)
            .disposed(by: disposeBag)
        
        fetchTrigger
            .withLatestFrom(page)
            .bind(to: searchAction.inputs)
            .disposed(by: disposeBag)
        
        reachedBottomTrigger
            .withLatestFrom(isLoading)
            .filter { !$0 }
            .withLatestFrom(page)
            .filter { $0 < 5 }
            .bind(to: searchAction.inputs)
            .disposed(by: disposeBag)
        
    }
}
