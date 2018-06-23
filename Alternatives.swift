//
//  Alternative.swift
//  Smartnet
//
//  Created by Art Zav on 5/11/18.
//

import Foundation
import UIKit

func alert(title: String, message: String, in vc: UIViewController) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default))
    vc.present(alert, animated: true, completion: nil)
}

func actionSheet(
        title: String? = "",
        message: String? = "",
        actions: Array<String> = [""],
        cancelTitle: String? = "Cancel",
        showCancelTitle: Bool = true,
        in vc: UIViewController
    
    ) {
    
    let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
    
    for indexTitle in actions {
        let indexAction =  UIAlertAction(title: indexTitle, style: .default,   handler: nil)
        actionSheet.addAction(indexAction)
    }
    
    let cancelAction =  UIAlertAction(title: cancelTitle, style: .cancel,   handler: nil)
    
    if showCancelTitle {
        actionSheet.addAction(cancelAction)
    }
    vc.present(actionSheet, animated: true, completion: nil)
}

