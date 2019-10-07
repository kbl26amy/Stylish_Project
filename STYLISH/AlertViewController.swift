//
//  AlertViewController.swift
//  STYLISH
//
//  Created by 楊雅涵 on 2019/7/24.
//  Copyright © 2019 AmyYang. All rights reserved.
//

import UIKit

extension UIAlertController {
    //在指定视图控制器上弹出普通消息提示框
    static func showAlert(message: String, in viewController: UIViewController) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ＯＫ", style: .cancel))
        viewController.present(alert, animated: true)
    }
    
    //在根视图控制器上弹出普通消息提示框
    static func showAlert(message: String) {
        if let viewController = UIApplication.shared.keyWindow?.rootViewController {
            showAlert(message: message, in: viewController)
        }
    }
    
    //在指定视图控制器上弹出确认框
    static func showConfirm(message: String, in viewController: UIViewController,
                            confirm: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "確定", style: .default, handler: confirm))
        viewController.present(alert, animated: true)
    }
    
    //在根视图控制器上弹出确认框
    static func showConfirm(message: String, confirm: ((UIAlertAction) -> Void)?) {
        if let viewController = UIApplication.shared.keyWindow?.rootViewController {
            showConfirm(message: message, in: viewController, confirm: confirm)
        }
    }
}
