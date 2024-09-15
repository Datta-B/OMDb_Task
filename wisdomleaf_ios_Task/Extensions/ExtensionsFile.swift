//
//  ExtensionsFile.swift
//  wisdomleaf_ios_Task
//
//  Created by dattaz biradar on 14/09/24.
//

import Foundation
import UIKit

extension UserDefaults {
    // Method to save Encodable object to UserDefaults
    func setObject<Object: Encodable>(_ object: Object, forKey: String) {
        if let data = try? JSONEncoder().encode(object) {
            set(data, forKey: forKey)
        }
    }
    
    // Method to retrieve Decodable object from UserDefaults
    func object<Object: Decodable>(_ type: Object.Type, withKey: String) -> Object? {
        if let data = data(forKey: withKey) {
            return try? JSONDecoder().decode(type, from: data)
        }
        return nil
    }
}
private var containerView: UIView?

extension UIViewController {
    public func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            child.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            child.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            child.view.topAnchor.constraint(equalTo: view.topAnchor),
            child.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        child.didMove(toParent: self)
    }
    
    public func remove(_ child: UIViewController) {
        guard child.parent != nil else {
            return
        }
        
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
    
}


