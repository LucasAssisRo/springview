//
//  SpringViewDelegate.swift
//  Margheritttta
//
//  Created by Lucas Assis Rodrigues on 14/06/2018.
//  Copyright © 2018 Lucas Assis Rodrigues. All rights reserved.
//

import UIKit

protocol SpringViewDelegate {
    func expand(to bounds: CGRect, animated: Bool, with duration: TimeInterval)
    func colapse(to bounds: CGRect, animated: Bool, with duration: TimeInterval)
}

extension Notification.Name {
    static let springExpand = Notification.Name("springExpand")
    static let springColapse = Notification.Name("springColapse")
}
