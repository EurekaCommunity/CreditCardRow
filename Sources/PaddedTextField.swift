//
//  PaddedTextField.swift
//  CreditCardRow
//
//  Created by Mathias Claassen on 9/1/16.
//
//

import UIKit

public class PaddedTextField : UITextField {
    public var padding : CGFloat = 18.0
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
        return CGRectMake(bounds.origin.x + padding, bounds.origin.y + padding, bounds.width - padding*2, bounds.height - padding*2)
    }
}