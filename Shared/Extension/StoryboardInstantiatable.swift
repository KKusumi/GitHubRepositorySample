//
//  StoryboardInstantiatable.swift
//  Shared
//
//  Created by kusumi on 2021/06/30.
//

import Foundation
import UIKit

public protocol StoryboardInstantiatable: UIViewController {}

public extension StoryboardInstantiatable {
    static func instantiate() -> Self {
        let name = String(describing: self.self)
        let bundle = Bundle(for: self.self)
        let storyboard = UIStoryboard(name: name, bundle: bundle) // nilだとアプリのMainのbundleを参照してしまう。
        return storyboard.instantiateInitialViewController() as! Self
    }
    static func instantiateWithNavigationController() -> UINavigationController {
        let name = String(describing: self.self)
        let bundle = Bundle(for: self.self)
        let storyboard = UIStoryboard(name: name, bundle: bundle)
        return storyboard.instantiateInitialViewController() as! UINavigationController
    }
}

extension NSObject {
    static var className: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    var className: String {
        return type(of: self).className
    }
}
