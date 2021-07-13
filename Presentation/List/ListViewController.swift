//
//  ListViewController.swift
//  Presentation
//
//  Created by kusumi on 2021/06/14.
//

import UIKit
import RxSwift
import RxCocoa
import Data
import Shared

public final class ListViewController: UIViewController {
    
    public static func make(with viewModel: ListViewModel) -> ListViewController {
        let view = ListViewController.instantiate()
        view.viewModel = viewModel
        return view
    }
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    private var viewModel: ListViewModelType!
    private let disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Bind ViewModel Outputs
        viewModel.outputs.navigationBarTitle
            .observe(on: MainScheduler.instance)
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        viewModel.outputs.gitHubRepositories
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items) { tableView, row, gitHubRepository in
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "subtitle")
                cell.textLabel?.text = "\(gitHubRepository.fullName)"
                cell.detailTextLabel?.textColor = UIColor.lightGray
                cell.detailTextLabel?.text = "\(gitHubRepository.description)"
                return cell
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(GitHubRepository.self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                let vc = DetailViewController.make(with: DetailViewModel(repository: $0))
                self?.navigationController?.pushViewController(vc, animated: true)
                    
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.isLoading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: $0 ? 50: 0, right: 0)
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.isLoading
            .observe(on: MainScheduler.instance)
            .bind(to: indicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.outputs.isLoading
            .observe(on: MainScheduler.instance)
             .subscribe(onNext: { [weak self] in
                 self?.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: $0 ? 50 : 0, right: 0)
             })
             .disposed(by: disposeBag)
        
        viewModel.outputs.error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                let ac = UIAlertController(title: "Error \($0)", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(ac, animated: true)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.reachedBottom
            .asObservable()
            .bind(to: viewModel.inputs.reachedBottomTrigger)
            .disposed(by: disposeBag)
        
        viewModel.inputs.fetchTrigger.onNext(())
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.indexPathsForSelectedRows?.forEach { [weak self] in
            self?.tableView.deselectRow(at: $0, animated: true)
        }
    }
}

extension ListViewController: StoryboardInstantiatable{}
