//
//  UIViewController+ShowAlert.swift
//  CatsApp
//
//  Created by Dmytro Yaremyshyn on 01/09/2024.
//

import UIKit

extension UIViewController {

    func showErrorDialog(title: String?, message: String?, cancelTitle: String?, actionTitle: String?, retryCompletion: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        // Cancel option
        let retryAction = UIAlertAction(title: actionTitle, style: .default) { _ in
            retryCompletion?()
        }
        alertController.addAction(retryAction)
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .destructive)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }
}
