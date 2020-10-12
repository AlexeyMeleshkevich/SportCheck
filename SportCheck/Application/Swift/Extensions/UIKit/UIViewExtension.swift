import UIKit

typealias Top_Bottom_Leading_Trailing = (CGFloat?, CGFloat?, CGFloat?, CGFloat?)

extension UIView {
    @IBInspectable var cornerRadius: Int {
        get {
            return Int(layer.cornerRadius)
        }
        set(newValue) {
            layer.cornerRadius = CGFloat(newValue)
        }
    }
    
    func pinSubviewAnchors(add: Bool, subview: UIView) {
        if add {
            addSubview(subview)
        }
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
        ])
    }
    
    func pinSubviewAnchors(add: Bool, subview: UIView, constants: Top_Bottom_Leading_Trailing) {
        if add {
            addSubview(subview)
        }
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraintConstant: CGFloat = constants.0 ?? 0.0
        let bottomConstraintConstant: CGFloat = constants.1 ?? 0.0
        let leadingConstraintConstant: CGFloat = constants.2 ?? 0.0
        let trailingConstraintConstant: CGFloat = constants.3 ?? 0.0
        
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: topAnchor, constant: topConstraintConstant),
            subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomConstraintConstant),
            subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: trailingConstraintConstant),
            subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingConstraintConstant)
        ])
    }
    
    func pinnedWithSubview(add: Bool, subview: UIView, constants: Top_Bottom_Leading_Trailing) -> UIView {
        if add {
            addSubview(subview)
        }
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraintConstant: CGFloat = constants.0 ?? 0.0
        let bottomConstraintConstant: CGFloat = constants.1 ?? 0.0
        let leadingConstraintConstant: CGFloat = constants.2 ?? 0.0
        let trailingConstraintConstant: CGFloat = constants.3 ?? 0.0
        
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: topAnchor, constant: topConstraintConstant),
            subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomConstraintConstant),
            subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: trailingConstraintConstant),
            subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingConstraintConstant)
        ])
        
        return self
    }
    
    func pinnedWithSubview(add: Bool, subview: UIView, top: CGFloat = 0.0, bottom: CGFloat = 0.0, leading: CGFloat = 0.0, trailing: CGFloat = 0.0) -> UIView {
        if add {
            addSubview(subview)
        }
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: topAnchor, constant: top),
            subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottom),
            subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: trailing),
            subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leading)
        ])
        
        return self
    }
    
    func pinnedWithSubview(add: Bool, subview: UIView) -> UIView {
        if add {
            addSubview(subview)
        }
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
        ])
        
        return self
    }
    
    func pinViewToBottom(viewToPin: UIView) {
        NSLayoutConstraint.activate([
            viewToPin.topAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
    
    func getWidthFromRatio(_ numerator: Int, to demominator: Int) -> CGFloat {
        return (bounds.width / CGFloat(demominator)) * CGFloat(numerator)
    }
    
    func getLeastWidthFromRation(_ numerator: Int, to demominator: Int) -> CGFloat {
        return bounds.width - ((bounds.width / CGFloat(demominator)) * CGFloat(numerator))
    }
}

extension UIView {
    func nukeAllAnimations() {
        subviews.forEach({$0.layer.removeAllAnimations()})
        layer.removeAllAnimations()
        layoutIfNeeded()
    }
}

extension UIView {
    var minXFrame: CGFloat {
        return frame.minX
    }

    var midXFrame: CGFloat {
        return frame.midX
    }
    
    var maxXFrame: CGFloat {
        return frame.maxX
    }
    
    var minYFrame: CGFloat {
        return frame.minY
    }
    
    var midYFrame: CGFloat {
        return frame.midY
    }
    
    var maxYFrame: CGFloat {
        return frame.maxY
    }
}
