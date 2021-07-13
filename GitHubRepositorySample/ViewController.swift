//
//  ViewController.swift
//  GitHubRepositorySample
//
//  Created by kusumi on 2021/06/13.
//

import UIKit
import Presentation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func onListScreenAction(_ sender: Any) {
        let vc = ListViewController.make(with: ListViewModel(language: "RxSwift"))
        navigationController?.pushViewController(vc, animated: true)
    }
}
