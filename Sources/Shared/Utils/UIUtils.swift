//
//  UIUtils.swift
//  PlacesUIKit
//
//  Created by Matoria, Ashok on 8/13/23.
//

import UIKit

final class UIUtils {
    static func showAlert(title: String, message: String, okTitle: String = NSLocalizedString("Ok", comment: "alert action title"), okAction: ((UIAlertAction) -> Void)?, cancelTitle: String? = nil, cancelAction: ((UIAlertAction) -> Void)? = nil) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAlertAction = UIAlertAction(title: okTitle, style: .default, handler: okAction)
        alertVC.addAction(okAlertAction)
        
        if cancelTitle?.isEmpty == false {
            let cancelAlertAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelAction)
            alertVC.addAction(cancelAlertAction)
        }
        
        // Note, currently this app does not support multiple scenes so we can ignore this warning
        Self.show(alertVC, topViewController: UIApplication.shared.keyWindow?.rootViewController)
    }
    
    static func addAndAnchorSubview(_ subview: UIView, to view: UIView) {
        view.addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        subview.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        subview.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        subview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private static func show(_ alert: UIAlertController, topViewController: UIViewController?) {
        if let nav = topViewController as? UINavigationController {
            show(alert, topViewController: nav.topViewController)
        } else if topViewController?.presentedViewController != nil {
            show(alert, topViewController: topViewController?.presentedViewController)
        } else {
            topViewController?.present(alert, animated: true)
        }
    }
}
