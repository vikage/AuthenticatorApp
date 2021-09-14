//
//  UIViewExtensions.swift
//  Core
//
//  Created by Thanh Vu on 10/06/2021.
//  Copyright © 2021 Solar. All rights reserved.
//

import Foundation
import UIKit
public extension UIView {
    @IBInspectable var borderWidth: CGFloat {
        set {
            self.layer.borderWidth = newValue
        }

        get {
            return self.layer.borderWidth
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            self.layer.borderColor = newValue?.cgColor
        }

        get {
            guard let cgcolor = self.layer.borderColor else { return nil }
            return UIColor.init(cgColor: cgcolor)
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
        }

        get {
            return self.layer.cornerRadius
        }
    }

    @IBInspectable var shadowOffset: CGSize {
        set {
            self.layer.shadowOffset = newValue
        }

        get {
            return self.layer.shadowOffset
        }
    }

    @IBInspectable var shadowRadius: CGFloat {
        set {
            self.layer.shadowRadius = newValue
        }

        get {
            return self.layer.shadowRadius
        }
    }

    @IBInspectable var shadowColor: UIColor? {
        set {
            self.layer.shadowColor = newValue?.cgColor
        }

        get {
            return self.layer.shadowColor != nil ? UIColor(cgColor: self.layer.shadowColor!) : nil
        }
    }

    @IBInspectable var shadowOpacity: Float {
        set {
            self.layer.shadowOpacity = newValue
        }

        get {
            return self.layer.shadowOpacity
        }
    }

    func fitSuperviewConstraint(edgeInset: UIEdgeInsets = .zero) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let superview = self.superview!
        self.topAnchor.constraint(equalTo: superview.topAnchor, constant: edgeInset.top).isActive = true
        self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: edgeInset.left).isActive = true
        self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -edgeInset.right).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -edgeInset.bottom).isActive = true
    }

    static func loadView(fromNib nibName: String, bundle: Bundle = Bundle.main) -> Self {
        guard let view = bundle.loadNibNamed(nibName, owner: nil, options: nil)?.last as? Self else {
            fatalError("Can not load view with type \(Self.self) in nib \"\(nibName)\" in bundle \(bundle)")
        }

        return view
    }

    func heightConstraint() -> NSLayoutConstraint? {
        var targetConstraint: NSLayoutConstraint?
        self.constraints.forEach { (constraint) in
            if (constraint.firstItem as? UIView) == self && constraint.firstAttribute == NSLayoutConstraint.Attribute.height {
                targetConstraint = constraint
            }
        }

        return targetConstraint
    }

    func setupCornerRadius(topLeftRadius: CGFloat, topRightRadius: CGFloat, bottomLeftRadius: CGFloat, bottomRightRadius: CGFloat) {
        let bezierPath = UIBezierPath.init(shouldRoundRect: self.bounds,
                                           topLeftRadius: topLeftRadius,
                                           topRightRadius: topRightRadius,
                                           bottomLeftRadius: bottomLeftRadius,
                                           bottomRightRadius: bottomRightRadius)
        let shape = CAShapeLayer()
        shape.backgroundColor = UIColor.white.cgColor
        shape.path = bezierPath.cgPath
        self.layer.mask = shape
    }

    static var bottomSafeArea: CGFloat {
        return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
    }
    
    static var topSafeArea: CGFloat {
        return UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
    }
    
    func disableInteractiveFor(seconds: Double) {
        self.isUserInteractionEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.isUserInteractionEnabled = true
        }
    }

    func drawImage(rect: CGRect) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: rect)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    var nibName: String {
        return type(of: self).description().components(separatedBy: ".").last! // to remove the module name and get only files name
    }
    
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil)[0] as! UIView
    }
}

public extension UIView {
    func image() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        context.saveGState()
        layer.render(in: context)
        context.restoreGState()
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        return image
    }
}

public extension UIView {
    var leadingConstraintWithSuperView: NSLayoutConstraint? {
        return self.getConstraintAttributeWithSuperView(.leading, superviewAttribute: .leading)
    }
    
    var trailingConstraintWithSuperView: NSLayoutConstraint? {
        return self.getConstraintAttributeWithSuperView(.trailing, superviewAttribute: .trailing)
    }
    
    var topConstraintWithSuperView: NSLayoutConstraint? {
        return self.getConstraintAttributeWithSuperView(.top, superviewAttribute: .top)
    }
    
    var bottomConstraintWithSuperView: NSLayoutConstraint? {
        return self.getConstraintAttributeWithSuperView(.bottom, superviewAttribute: .bottom)
    }
    
    private func getConstraintAttributeWithSuperView(_ attribute: NSLayoutConstraint.Attribute, superviewAttribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        guard let superview = self.superview else {
            return nil
        }
        
        let superviewConstraint = superview.constraints
        for constraint in superviewConstraint {
            if (constraint.firstItem as? UIView == self.superview && constraint.secondItem as? UIView == self) {
                if constraint.firstAttribute == superviewAttribute && constraint.secondAttribute == attribute {
                    return constraint
                }
            }
            
            if (constraint.secondItem as? UIView == self.superview && constraint.firstItem as? UIView == self) {
                if constraint.firstAttribute == attribute && constraint.secondAttribute == superviewAttribute {
                    return constraint
                }
            }
        }
        
        return nil
    }
}
