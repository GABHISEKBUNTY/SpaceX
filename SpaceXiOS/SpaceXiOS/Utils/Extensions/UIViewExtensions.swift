//
//  UIViewExtensions.swift
//  SpaceXiOS
//
//  Created by G Abhisek on 28/05/21.
//

import UIKit

extension UIView {
    static func buildView<T: UIView>(_ builder: ((T) -> Void)? = nil) -> T {
        let view = T()
        view.translatesAutoresizingMaskIntoConstraints = false
        builder?(view)
        return view
    }
}
