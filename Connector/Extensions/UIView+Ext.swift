import UIKit

// MARK: Constraints
extension UIView {
    func throwNoSuperviewError() {
        fatalError("Attempting to set constraints to a \(type(of: self)) before adding it to a superView")
    }
    
    func fillScreen() {
        guard let superview = superview else {
            throwNoSuperviewError()
            return
        }
        disableAutoresizingMaskTranslationIfEnabled()
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight),
            widthAnchor.constraint(equalToConstant: LayoutConstants.screenWidth),
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor),
        ])
    }
    
    func fillSuperView() {
        guard let superview = superview else {
            throwNoSuperviewError()
            return
        }
        
        disableAutoresizingMaskTranslationIfEnabled()
        fill(superview)
    }
    
    /// make `self` fill the specified `view` with specified margins.
    func fill(_ view: UIView, top: CGFloat=0, leading: CGFloat=0, bottom: CGFloat=0, trailing: CGFloat=0) {
        disableAutoresizingMaskTranslationIfEnabled()
        
        constrainEdgesToCorrespondingEdges(of: view, top: top, leading: leading, bottom: bottom, trailing: trailing)
    }
    
    /// Constrain 4 edges of `self` to specified `view`.
    func constrainEdgesToCorrespondingEdges(of view: UIView, top: CGFloat?=nil, leading: CGFloat?=nil, bottom: CGFloat?=nil, trailing: CGFloat?=nil) {
        disableAutoresizingMaskTranslationIfEnabled()
        
        if let top = top {
            topAnchor.constraint(equalTo: view.topAnchor, constant: top).isActive = true
        }
        if let leading = leading {
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leading).isActive = true
            
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom).isActive = true
            
        }
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailing).isActive = true
        }
        
    }
    
    /// Constrain width and height of `self` to specified constants.
    func constrainDimensions(width: CGFloat?=nil, height: CGFloat?=nil) {
        disableAutoresizingMaskTranslationIfEnabled()
        
        var constraints: [NSLayoutConstraint] = []
        
        if let width = width { constraints.append(widthAnchor.constraint(equalToConstant: width)) }
        if let height = height { constraints.append(heightAnchor.constraint(equalToConstant: height)) }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    /// Constrain width and height of `self` to specified view with specified multipliers.
    func constrainDimensions(to view:UIView, widthMultiplier: CGFloat?=nil, heightMultiplier: CGFloat?=nil) {
        disableAutoresizingMaskTranslationIfEnabled()
        
        var constraints: [NSLayoutConstraint] = []
        
        if let widthMultiplier = widthMultiplier {
            constraints.append(widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: widthMultiplier))
        }
        if let heightMultiplier = heightMultiplier {
            constraints.append(heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: heightMultiplier))
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func centerVertically(relativeTo view: UIView?=nil) {
        disableAutoresizingMaskTranslationIfEnabled()
        guard let view = view ?? self.superview else {
            throwNoSuperviewError()
            return
        }
        
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func centerHorizontally(relativeTo view: UIView?=nil) {
        disableAutoresizingMaskTranslationIfEnabled()
        guard let view = view ?? self.superview else {
            throwNoSuperviewError()
            return
        }
        
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    /// Centers the view both vertically and horizontally relative to the specified `view` or superview.
    func center(relativeTo view: UIView?=nil) {
        disableAutoresizingMaskTranslationIfEnabled()
        guard let view = view ?? self.superview else {
            throwNoSuperviewError()
            return
        }
        centerVertically(relativeTo: view)
        centerHorizontally(relativeTo: view)
    }
    
    private func disableAutoresizingMaskTranslationIfEnabled() {
        if translatesAutoresizingMaskIntoConstraints {
            translatesAutoresizingMaskIntoConstraints = false
        }
    }
}

// MARK: Effects
extension UIView {
	static let blurEffectTag = -1
    static let cascadingViewTag = -2
    
    func addBlurEffect(style: UIBlurEffect.Style, withCascadingColor cascadingColor: UIColor? = nil) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        clipsToBounds = true
        
        blurEffectView.isUserInteractionEnabled = false
        blurEffectView.tag = UIView.blurEffectTag
        
        addSubview(blurEffectView)
        blurEffectView.fillSuperView()
        
        if let cascadingColor = cascadingColor {
            let cascadingView = UIView(frame: .zero)
            
            cascadingView.tag = UIView.cascadingViewTag
            cascadingView.backgroundColor = cascadingColor
            
            addSubview(cascadingView)
            cascadingView.fillSuperView()
        }
    }
    
    func removeBlurEffect() {
        viewWithTag(UIView.blurEffectTag)?.removeFromSuperview()
    }
            	
	func scale(to scale: CGFloat) {
		self.transform = CGAffineTransform(scaleX: scale, y: scale)
	}
}

// MARK: Tools
extension UIView {
    func roundAsCircle() {
        self.layer.cornerRadius = self.frame.height / 2;
        self.layer.masksToBounds = true
		self.clipsToBounds = true
    }
}

// MARK: Computed Proprieties
extension UIView {
    var globalPoint :CGPoint? {
        return self.superview?.convert(self.frame.origin, to: nil)
    }
    
    var globalFrame :CGRect? {
        return self.superview?.convert(self.frame, to: nil)
    }
    
    var firstResponder: UIView? {
        guard !isFirstResponder else { return self }
        
        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }
        
        return nil
    }	
}
