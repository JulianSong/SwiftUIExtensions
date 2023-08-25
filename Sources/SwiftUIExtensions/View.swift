//
//  File.swift
//  
//
//  Created by songjunliang on 2023/8/22.
//

import UIKit

extension UINavigationController {
    override open func viewWillLayoutSubviews() {
        navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
