//
//  iOS.swift
//  CreditCardRow
//
//  Copyright © 2016 Xmartlabs SRL. All rights reserved.
//

import Foundation
import Eureka
//import SwiftLuhn

public struct CreditCardInfo : Equatable {
    var creditCardNumber : String?
    var expiration : String?
    var cvc : String?
}

public func ==(lhs: CreditCardInfo, rhs: CreditCardInfo) -> Bool {
    return (lhs.creditCardNumber == rhs.creditCardNumber && lhs.expiration == rhs.expiration && lhs.cvc == rhs.cvc)
}

public class CreditCardCell: Cell<CreditCardInfo>, UITextFieldDelegate, CellType {

    @IBOutlet weak var horizontalSeparator: UIView!
    @IBOutlet weak var verticalSeparator: UIView!

    @IBOutlet weak var numberField: PaddedTextField!
    @IBOutlet weak var expirationField: PaddedTextField!
    @IBOutlet weak var cvcField: PaddedTextField!

    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    public override func setup() {
        super.setup()
        height = { 56 * 2 }
        selectionStyle = .None
        numberField.padding = 16.0
        expirationField.padding = 16.0
        cvcField.padding = 18.0

        horizontalSeparator.backgroundColor = .grayColor()
        verticalSeparator.backgroundColor = .grayColor()

        for field in [numberField, expirationField, cvcField] {
            field.autocorrectionType = .No
            field.autocapitalizationType = .None
            field.keyboardType = .NumberPad
            field.font = .systemFontOfSize(24)
            field.minimumFontSize = 14.0
            field.addTarget(self, action: #selector(CreditCardCell.textFieldEditingChanged(_:)), forControlEvents: .EditingChanged)
            field.delegate = self
        }

        cvcField.secureTextEntry = true
    }

    public override func update() {
        super.update()
        textLabel?.text = nil

        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.grayColor().CGColor

        numberField.text = row.value?.creditCardNumber
        numberField.placeholder = NSLocalizedString("Card Number", comment: "Card Number placeholder")

        cvcField.text = row.value?.cvc
        cvcField.placeholder = NSLocalizedString("Card CVC", comment: "Card CVC placeholder")

        expirationField.text = row.value?.expiration
        expirationField.placeholder = NSLocalizedString("MM/YY", comment: "Card Expiration placeholder")
    }

    func updateValuesForTextField(textField: UITextField) {
        switch(textField){
        case numberField:
            row.value?.creditCardNumber = textField.text
        case expirationField:
            row.value?.expiration = textField.text
        case cvcField:
            row.value?.cvc = textField.text
        default: break
        }
    }

    public lazy var naview: NavigationAccessoryView = { [unowned self] in
        return NavigationAccessoryView(frame: CGRectMake(0, 0, self.frame.width, 44.0))
        }()

    override public func cellCanBecomeFirstResponder() -> Bool {
        return !row.isDisabled
    }

    public override func cellBecomeFirstResponder(direction: Direction) -> Bool {
        switch direction {
        case .Up:
            return cvcField.becomeFirstResponder()
        case .Down:
            return numberField.becomeFirstResponder()
        }
    }

    //MARK: Navigation
    override public var inputAccessoryView: UIView? {
        if let v = formViewController()?.inputAccessoryViewForRow(row) as? NavigationAccessoryView{

            if numberField.isFirstResponder() {
                v.nextButton.enabled = true
                v.nextButton.target = self
                v.nextButton.action = #selector(CreditCardCell.internalNavigationAction(_:))
                return v
            }
            else if expirationField.isFirstResponder() {
                v.previousButton.target = self
                v.previousButton.action = #selector(CreditCardCell.internalNavigationAction(_:))
                v.nextButton.target = self
                v.nextButton.action = #selector(CreditCardCell.internalNavigationAction(_:))
                v.previousButton.enabled = true
                v.nextButton.enabled = true
                return naview
            }
            else if cvcField.isFirstResponder() {
                v.previousButton.enabled = true
                v.previousButton.target = self
                v.previousButton.action = #selector(CreditCardCell.internalNavigationAction(_:))
                return naview
            }
            return v
        }
        return super.inputAccessoryView
    }

    func internalNavigationAction(sender: UIBarButtonItem) {
        if numberField.isFirstResponder() {
            expirationField.becomeFirstResponder()
        }
        else if expirationField.isFirstResponder() {
            sender == naview.previousButton ? numberField.becomeFirstResponder() : cvcField.becomeFirstResponder()
        }
        else if cvcField.isFirstResponder() {
            expirationField.becomeFirstResponder()
        }
    }

    //MARK: UITextFieldDelegate
    public func textFieldEditingChanged(textField: UITextField) {
        updateValuesForTextField(textField)
    }

    @objc public func textFieldDidEndEditing(textField: UITextField) {
        updateValuesForTextField(textField)
    }
}
