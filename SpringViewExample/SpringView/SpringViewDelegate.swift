//
//  SpringViewDelegate.swift
//  Margheritttta
//
//  Created by Lucas Assis Rodrigues on 14/06/2018.
//  Copyright © 2018 Lucas Assis Rodrigues. All rights reserved.
//

import UIKit

/**
    Implement this protocol to handle the spring view events on the embedded view controller
 */
protocol SpringViewDelegate {
    
    /**
     Handle the expand event.
     - parameters:
         - bounds: The expanded bounding box.
         - animated: If the transition is going to be animated or not.
         - duration: Duration of the animations.
     */
    
    func expand(to bounds: CGRect, animated: Bool, with duration: TimeInterval)
    
    /**
     Handle the colapse event.
     - parameters:
         - bounds: The colapsed bounding box.
         - animated: If the transition is going to be animated or not.
         - duration: Duration of the animations.
     */
    
    func colapse(to bounds: CGRect, animated: Bool, with duration: TimeInterval)
}

extension Notification.Name {
    static let springExpand = Notification.Name("springExpand")
    static let springColapse = Notification.Name("springColapse")
}
