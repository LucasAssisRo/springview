//
//  SpringView.swift
//  SpringModalAnimation
//
//  Created by Lucas Assis Rodrigues on 13/06/2018.
//  Copyright © 2018 Lucas Assis Rodrigues. All rights reserved.
//

import UIKit

@IBDesignable
class SpringView: UIView {
    var delegate: SpringViewDelegate?
    
    private var shrink = CGAffineTransform(scaleX: 1, y: 1)
    var smallFrame: CGRect!
    
    var closeButton: UIButton!
    private let closeButtonRadius: CGFloat = 20
    private var closeButtonCenter: CGPoint {
        return CGPoint(x: self.bounds.maxX - self.closeButtonRadius - 16,
                       y: self.bounds.minY + self.closeButtonRadius + 44)
    }
    
    var containerView: UIView!
    var embededViewController: UIViewController?
    
    private let roundCornerAnimation = CABasicAnimation(keyPath: "cornerRadius")
    private let sharpCornerAnimation = CABasicAnimation(keyPath: "cornerRadius")
    
    private var subviewColapsedCenters: [CGPoint] = []
    private var subviewExpandedCenters: [CGPoint] = []
    
    var isPresenting = false
    
    @IBInspectable var animationDuration: CGFloat = 0
    
    @IBInspectable var shrinkX: CGFloat = 0 {
        didSet {
            self.shrink = CGAffineTransform(scaleX: self.shrinkX, y: self.shrinkY)
        }
    }
    
    @IBInspectable var shrinkY: CGFloat = 0 {
        didSet {
            self.shrink = CGAffineTransform(scaleX: self.shrinkX, y: self.shrinkY)
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = .zero {
        didSet {
            self.layer.shadowOffset = self.shadowOffset
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet {
            self.layer.shadowRadius = self.shadowRadius
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0 {
        didSet {
            self.layer.shadowOpacity = self.shadowOpacity
        }
    }
    
    @IBInspectable var shadowColor: UIColor = .clear {
        didSet {
            self.layer.shadowColor = self.shadowColor.cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.constructor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.constructor()
    }
    
    private func constructor() {
        self.closeButton = UIButton()
        self.closeButton.frame.size = CGSize(width: self.closeButtonRadius * 2,
                                             height: self.closeButtonRadius * 2)
        self.closeButton.layer.cornerRadius = self.closeButtonRadius
        self.closeButton.setTitle("X", for: .normal)
        self.closeButton.setTitleColor(UIColor.white.withAlphaComponent(0.9), for: .normal)
        self.closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .black)
        self.closeButton.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.closeButton.addTarget(self, action: #selector(self.colapseView), for: .touchUpInside)
        self.closeButton.alpha = 0
        self.closeButton.center = self.closeButtonCenter
        self.closeButton.tag = Tag.closeButton.rawValue
        self.addSubview(self.closeButton)
        
        self.containerView = UIView()
        self.containerView.tag = Tag.containerView.rawValue
        self.containerView.layer.masksToBounds = true
        self.addSubview(self.containerView)
        
        self.roundCornerAnimation.toValue = 5
        self.roundCornerAnimation.duration = TimeInterval(self.animationDuration)
        self.roundCornerAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.roundCornerAnimation.fillMode = kCAFillModeForwards
        self.roundCornerAnimation.autoreverses = false
        self.roundCornerAnimation.isRemovedOnCompletion = false
        
        self.sharpCornerAnimation.toValue = 0
        self.roundCornerAnimation.duration = TimeInterval(self.animationDuration)
        self.sharpCornerAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.sharpCornerAnimation.fillMode = kCAFillModeForwards
        self.sharpCornerAnimation.autoreverses = false
        self.sharpCornerAnimation.isRemovedOnCompletion = false
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        if self.smallFrame == nil {
            self.smallFrame = self.frame
            self.containerView.frame = self.bounds
            self.containerView.layer.cornerRadius = self.cornerRadius
            self.bringSubview(toFront: self.closeButton)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let _ = touches.first else { return }
        
        if !self.isPresenting {
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           options: [.layoutSubviews, .allowAnimatedContent, .curveEaseIn],
                           animations: {
                            self.transform = self.shrink
            })
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let superview = self.superview else { return }
        superview.bringSubview(toFront: self)
        if self.subviewColapsedCenters.count == 0 {
            self.indexSubviews(superview)
        }
        
        if !self.isPresenting {
            self.expandView(in: superview, animated: true)
        }
    }
    
    func embed(viewController: UIViewController, in parent: UIViewController, delegate: SpringViewDelegate) {
        parent.addChildViewController(viewController)
        self.containerView.addSubview(viewController.view)
        self.delegate = delegate
        viewController.view.frame = self.containerView.bounds
        viewController.view.isUserInteractionEnabled = false
        viewController.didMove(toParentViewController: parent)
        self.embededViewController = viewController
    }
    
    @objc func expandView(in superview: UIView, animated: Bool = true) {
        print("spring view expand")
        self.bringSubview(toFront: self.closeButton)
        NotificationCenter.default.post(name: .springExpand, object: self, userInfo: [
            "superview": superview,
            "animated" : animated,
            "duration": self.animationDuration
            ])
        
        UIView.animate(withDuration: !animated ? 0 : 0.1,
                       delay: 0,
                       options: [.layoutSubviews, .allowAnimatedContent, .curveLinear],
                       animations: {
                        self.transform = .identity
        }) { finished in
            self.layer.add(self.sharpCornerAnimation, forKey: "cornerRadius")
            self.containerView.layer.add(self.sharpCornerAnimation, forKey: "cornerRadius")
            self.isPresenting = true
            UIView.animate(withDuration: !animated ? 0 : TimeInterval(self.animationDuration),
                           delay: 0,
                           options: [.layoutSubviews, .allowAnimatedContent, .curveEaseOut],
                           animations: {
                            self.frame = UIScreen.main.bounds
                            
                            self.closeButton.alpha = 1
                            for (i, view) in self.subviews.enumerated() {
                                if view.tag == Tag.containerView {
                                    view.frame = self.bounds
                                    self.embededViewController?.view.frame = view.bounds
                                    self.embededViewController?.view.isUserInteractionEnabled = true
                                    self.delegate?.expand(to: self.bounds,
                                                          animated: animated,
                                                          with: TimeInterval(self.animationDuration))
                                } else {
                                    view.center.x = self.subviewExpandedCenters[i].x
                                }
                            }
            })
        }
    }
    
    
    @objc func colapseView(_ sender: Any, animated: Bool = true) {
        print("spring view colapse")
        NotificationCenter.default.post(name: .springColapse, object: self, userInfo: [
            "animated" : animated,
            "duration": self.animationDuration
            ])
        
        let animated = sender is  UIButton
        self.layer.add(self.roundCornerAnimation, forKey: "cornerRadius")
        self.containerView.layer.add(self.roundCornerAnimation, forKey: "cornerRadius")
        self.isPresenting = false
        
        UIView.animate(withDuration: TimeInterval(!animated ? 0 : self.animationDuration),
                       delay: 0,
                       options: [.layoutSubviews, .allowAnimatedContent, .curveEaseIn],
                       animations: {
                        self.frame = self.smallFrame
                        self.closeButton.alpha = 0
                        for (i, view) in self.subviews.enumerated() {
                            if view.tag == Tag.containerView {
                                view.frame = self.bounds
                                self.embededViewController?.view.frame = view.bounds
                                self.embededViewController?.view.isUserInteractionEnabled = false
                                self.delegate?.colapse(to: self.bounds,
                                                       animated: animated,
                                                       with: TimeInterval(self.animationDuration))
                            } else {
                                view.center.x = self.subviewColapsedCenters[i].x
                            }
                        }
        }) { finished in
            UIView.animate(withDuration: !animated ? 0 : 0.1,
                           delay: 0,
                           options: [.layoutSubviews, .allowAnimatedContent, .curveLinear],
                           animations: {
                            self.transform = self.shrink
            }) { finished in
                UIView.animate(withDuration: !animated ? 0 : 0.1,
                               delay: 0,
                               options: [.layoutSubviews, .allowAnimatedContent, .curveEaseOut],
                               animations: {
                                self.transform = .identity
                })
            }
        }
    }
    
    func indexSubviews(_ superview: UIView) {
        self.subviewColapsedCenters.removeAll()
        self.subviewExpandedCenters.removeAll()
        for view in self.subviews {
            self.subviewColapsedCenters.append(view.center)
            self.subviewExpandedCenters.append(CGPoint(x: view.center.x / self.bounds.width * superview.bounds.width,
                                                       y: view.center.y / self.bounds.height * superview.bounds.height))
        }
    }
    
    enum Tag: Int {
        case unspecified = 0
        case closeButton = 1000
        case containerView = 2000
        
        static func ==(left: Int, right: SpringView.Tag) -> Bool {
            return left == right.rawValue
        }
        
        static func ==(left: SpringView.Tag, right: Int) -> Bool {
            return left.rawValue == right
        }
        
        static func !=(left: Int, right: SpringView.Tag) -> Bool {
            return left != right.rawValue
        }
        
        static func !=(left: SpringView.Tag, right: Int) -> Bool {
            return left.rawValue != right
        }
    }
}

extension CGPoint {
    static func +=(left: inout CGPoint, right: CGPoint) {
        left = CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
}
