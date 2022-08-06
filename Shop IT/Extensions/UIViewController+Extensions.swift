//
//  Extensions.swift
//  Shop IT
//
//  Created by Ozan on 5.08.2022.
//

import UIKit
import SPIndicator

extension UIViewController {
    func customAlert(_ message: String)
    {
        SPIndicatorView(title: message, preset: .done).present(duration: 2)
    }
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func showAlert(_ title: String, message: String, completionHandler: @escaping (_ success: Bool) -> Void)
    {
        let pAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        pAlert.addAction(UIAlertAction(title: "Evet", style: .default, handler: { (action: UIAlertAction!) in
            completionHandler(true)
        }))

        pAlert.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: { (action: UIAlertAction!) in
            completionHandler(false)
        }))

        self.present(pAlert, animated: true, completion: nil)
    }
}
