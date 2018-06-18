//
//  MainViewController.swift
//  SpringViewExample
//
//  Created by Lucas Assis Rodrigues on 18/06/2018.
//  Copyright © 2018 Lucas Assis Rodrigues. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    private var _isStatusBarHidden: Bool = false
    
    var isStatusBarHidden: Bool {
        get {
            return self._isStatusBarHidden
        }
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool {
        return self._isStatusBarHidden
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(expandSpring(_:)),
                                               name: NSNotification.Name.springExpand,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(colapseSpring(_:)),
                                               name: NSNotification.Name.springColapse,
                                               object: nil)
        
        for subview in self.view.subviews {
            if let springView = subview as? SpringView,
                let embededViewController = storyboard?
                    .instantiateViewController(withIdentifier: "example") as? ExampleViewController {
                
                springView.embed(viewController: embededViewController, in: self, delegate: embededViewController)
            }
        }
    }

    func setStatusBarHidden(_ isHidden: Bool, with duration: TimeInterval) {
        self._isStatusBarHidden = isHidden
        UIView.animate(withDuration: duration) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    @objc func expandSpring(_ notification: NSNotification) {
        print("notification expand")
        if let info = notification.userInfo,
            let superview = info["superview"] as? UIView,
            let animated = info["animated"] as? Bool,
            let duration = info["duration"] as? CGFloat {
            self.setStatusBarHidden(animated, with: TimeInterval(duration))
        }
    }
    
    @objc func colapseSpring(_ notification: NSNotification) {
        print("notification colapse")
        if let info = notification.userInfo,
            let animated = info["animated"] as? Bool,
            let duration = info["duration"] as? CGFloat {
            self.setStatusBarHidden(animated, with: TimeInterval(duration))
        }
    }
}
