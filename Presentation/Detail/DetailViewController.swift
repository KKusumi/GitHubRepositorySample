//
//  DetailViewController.swift
//  Presentation
//
//  Created by kusumi on 2021/06/30.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import WebKit
import RxWebKit
import Shared

final class DetailViewController: UIViewController {
    
    static func make(with viewModel: DetailViewModel) -> DetailViewController {
        let view = DetailViewController.instantiate()
        view.viewModel = viewModel
        return view
    }
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var webView: WKWebView!
    
    private var viewModel: DetailViewModelType!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.outputs.navigationBarTitle
            .observe(on: MainScheduler.instance)
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        webView.rx.loading
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: indicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        webView.load(viewModel.outputs.request)
    }
}

extension DetailViewController: StoryboardInstantiatable {}
