//
//  Extensions.swift
//  Armsprime_IOSAssignment
//
//  Created by Siva Kumar Aketi on 29/01/20.
//  Copyright © 2020 SivaKumarAketi. All rights reserved.
//

import UIKit
//for alertview
extension UIViewController {
    func alertMessageOK(for alert: String) {
        let alert = UIAlertController(title: title, message: alert, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)

    }
}


extension UIImageView{
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 3)
       // rotation.duration = 2
        rotation.isCumulative = true
        //rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
}

