//
//  UIImageViewExtensions.swift
//  SpaceXiOS
//
//  Created by G Abhisek on 29/05/21.
//

import UIKit

extension UIImageView {
    func load(url: URL, completion: ((Bool) -> Void)? = nil) {
        DispatchQueue.global().async { [weak self] in
            let sessionTask = URLSession.shared.dataTask(with: url) { (apiData, _, _) in
                if let data = apiData {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.image = image
                            completion?(true)
                            return
                        }
                    }
                }
                
                completion?(false)
            }
            
            sessionTask.resume()
        }
    }
}
