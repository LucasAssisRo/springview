//
//  ExampleViewController.swift
//  SpringViewExample
//
//  Created by Lucas Assis Rodrigues on 18/06/2018.
//  Copyright © 2018 Lucas Assis Rodrigues. All rights reserved.
//

import UIKit

class ExampleViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
}

extension ExampleViewController: SpringViewDelegate {
    func expand(to bounds: CGRect, animated: Bool, with duration: TimeInterval) {
        print("delegate expand")
        UIView.transition(with: self.label,
                          duration: duration,
                          options: .transitionCrossDissolve,
                          animations: { self.label.textColor = .orange })
    }
    
    func colapse(to bounds: CGRect, animated: Bool, with duration: TimeInterval) {
        print("delegate colapse")
        UIView.transition(with: self.label,
                          duration: duration,
                          options: .transitionCrossDissolve,
                          animations: { self.label.textColor = .black })
    }
}
