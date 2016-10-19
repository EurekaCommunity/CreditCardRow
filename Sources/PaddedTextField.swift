//
//  PaddedTextField.swift
//  CreditCardRow
//
//  Created by Mathias Claassen on 9/1/16.
//
//

import UIKit

/// UITextField subclass that inserts a padding around the text rect.
open class PaddedTextField : UITextField {

    /// Padding value to apply around text rect. Used to apply the same padding vertically and horizontally. Getter returns horizontalPadding.
    public var padding: CGFloat {
        set {
            horizontalPadding = newValue
            verticalPadding = newValue
        }
        get { return horizontalPadding }
    }

    /// Horizontal padding for text field
    public var horizontalPadding : CGFloat = 18.0

    /// Vertical padding for text field
    public var verticalPadding : CGFloat = 18.0
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return myRectForBounds(bounds)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return myRectForBounds(bounds)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return myRectForBounds(bounds)
    }

    func myRectForBounds(_ bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + horizontalPadding, y: bounds.origin.y + verticalPadding,
                          width: bounds.width - horizontalPadding * 2, height: bounds.height - verticalPadding * 2)
    }
}
