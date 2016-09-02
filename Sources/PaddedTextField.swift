//
//  PaddedTextField.swift
//  CreditCardRow
//
//  Created by Mathias Claassen on 9/1/16.
//
//

import UIKit

/// UITextField subclass that inserts a padding around the text rect.
public class PaddedTextField : UITextField {

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
    
    override public func textRectForBounds(bounds: CGRect) -> CGRect {
        return myRectForBounds(bounds)
    }

    override public func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        return myRectForBounds(bounds)
    }

    override public func editingRectForBounds(bounds: CGRect) -> CGRect {
        return myRectForBounds(bounds)
    }

    func myRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectMake(bounds.origin.x + horizontalPadding, bounds.origin.y + verticalPadding,
                          bounds.width - horizontalPadding * 2, bounds.height - verticalPadding * 2)
    }
}
