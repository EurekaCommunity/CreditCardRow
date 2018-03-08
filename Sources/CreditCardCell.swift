//
//  iOS.swift
//  CreditCardRow
//
//  Copyright © 2016 Xmartlabs SRL. All rights reserved.
//

import Foundation
import Eureka

/**
 *  Struct holding the value for a CreditCardRow
 */
public struct CreditCardInfo : Equatable {
    public var creditCardNumber : String?
    public var expiration : String?
    public var cvv : String?
    
    public init() { }
}

public func ==(lhs: CreditCardInfo, rhs: CreditCardInfo) -> Bool {
    return (lhs.creditCardNumber == rhs.creditCardNumber && lhs.expiration == rhs.expiration && lhs.cvv == rhs.cvv)
}

open class CreditCardCell: Cell<CreditCardInfo>, UITextFieldDelegate, CellType {

    /// Horizontal separator between number field and expiration and CVV fields in original cell
    @IBOutlet public weak var horizontalSeparator: UIView?

    /// Vertical separator between expiration and CVV fields in original cell
    @IBOutlet public weak var verticalSeparator: UIView?

    /// Text field for the credit card number.
    @IBOutlet public weak var numberField: PaddedTextField!

    /// Text field for the expiration date of the credit card
    @IBOutlet public weak var expirationField: PaddedTextField?

    /// Text field for the CVV value
    @IBOutlet public weak var cvvField: PaddedTextField?

    // Variables used to save temporary information about number text field
    fileprivate var previousTextFieldContent: String?
    fileprivate var previousSelection: UITextRange?

    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    open override func setup() {
        super.setup()
        height = { 56 * 2 }
        selectionStyle = .none
        numberField.padding = 16.0
        expirationField?.padding = 16.0
        cvvField?.padding = 18.0

        horizontalSeparator?.backgroundColor = .gray
        verticalSeparator?.backgroundColor = .gray

        for field in [numberField, expirationField, cvvField] {
            field?.autocorrectionType = .no
            field?.autocapitalizationType = .none
            field?.keyboardType = .numberPad
            field?.font = .systemFont(ofSize: 24)
            field?.minimumFontSize = 14.0
            field?.addTarget(self, action: #selector(CreditCardCell.textFieldEditingChanged(_:)), for: .editingChanged)
            field?.delegate = self
        }

        cvvField?.isSecureTextEntry = true
    }

    open override func update() {
        super.update()
        textLabel?.text = nil

        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.gray.cgColor

        numberField.text = row.value?.creditCardNumber
        reformatAsCardNumber(numberField)
        numberField.placeholder = NSLocalizedString("Card Number", comment: "Card Number placeholder")

        if let cvvField = cvvField {
            cvvField.text = row.value?.cvv
            reformatAsCVV(cvvField)
            cvvField.placeholder = NSLocalizedString("Card CVV", comment: "Card CVV placeholder")
        }

        if let expirationField = expirationField {
            expirationField.text = row.value?.expiration
            reformatAsExpiration(expirationField)
            expirationField.placeholder = NSLocalizedString("MM\(ccrow.expirationSeparator)YY", comment: "Card Expiration placeholder")
        }
    }

    /**
     Update row.value for a certain textfield.

     - parameter textField: The textfield from which to obtain a value
     */
    func updateValuesForTextField(_ textField: UITextField) {
        switch(textField){
        case numberField:
            row.value?.creditCardNumber = textField.text?.replacingOccurrences(of: ccrow.numberSeparator, with: "", options: .literal, range: nil)
        case expirationField!:
            row.value?.expiration = textField.text
        case cvvField!:
            row.value?.cvv = textField.text
        default: break
        }
    }

    /// Strong-typed row
    fileprivate var ccrow: _CreditCardRow {
        return row as! _CreditCardRow
    }

    override open func cellCanBecomeFirstResponder() -> Bool {
        return !row.isDisabled
    }

    open override func cellBecomeFirstResponder(withDirection direction: Direction) -> Bool {
        switch direction {
        case .up:
            return cvvField?.becomeFirstResponder() ?? expirationField?.becomeFirstResponder() ?? numberField.becomeFirstResponder()
        case .down:
            return numberField.becomeFirstResponder()
        }
    }

    //MARK: Navigation


    override open var inputAccessoryView: UIView? {
        // get the default accessory view and override some methods for internal navigation
        if let v = formViewController()?.inputAccessoryView(for: row) as? NavigationAccessoryView{
            if numberField.isFirstResponder {
                v.nextButton.isEnabled = true
                v.nextButton.target = self
                v.nextButton.action = #selector(CreditCardCell.internalNavigationAction(_:))
                return v
            }
            else if expirationField?.isFirstResponder == true {
                v.previousButton.target = self
                v.previousButton.action = #selector(CreditCardCell.internalNavigationAction(_:))
                v.nextButton.target = self
                v.nextButton.action = #selector(CreditCardCell.internalNavigationAction(_:))
                v.previousButton.isEnabled = true
                v.nextButton.isEnabled = true
                return v
            }
            else if cvvField?.isFirstResponder == true {
                v.previousButton.isEnabled = true
                v.previousButton.target = self
                v.previousButton.action = #selector(CreditCardCell.internalNavigationAction(_:))
                return v
            }
            return v
        }
        return super.inputAccessoryView
    }

    /// Internal function that handles the tap of the row navigation buttons
    @objc func internalNavigationAction(_ sender: UIBarButtonItem) {
        guard let inputAccessoryView  = inputAccessoryView as? NavigationAccessoryView else { return }

        if numberField.isFirstResponder {
            expirationField?.becomeFirstResponder()
        }
        else if expirationField?.isFirstResponder == true {
            _ = (sender == inputAccessoryView.previousButton ? numberField.becomeFirstResponder() : cvvField?.becomeFirstResponder())
        }
        else if cvvField?.isFirstResponder == true {
            expirationField?.becomeFirstResponder()
        }
    }

    //MARK: UITextFieldDelegate
    @objc open func textFieldEditingChanged(_ textField: UITextField) {
        updateValuesForTextField(textField)
        switch textField {
        case numberField:
            reformatAsCardNumber(textField)
        case expirationField!:
            reformatAsExpiration(textField)
        case cvvField!:
            reformatAsCVV(textField)
        default: break
        }
    }

    @objc open func textFieldDidEndEditing(_ textField: UITextField) {
        updateValuesForTextField(textField)
    }

    open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Save textField's current state before performing the change, in case
        // reformatAsCardNumber wants to revert it
        switch textField {
        case numberField:
            previousTextFieldContent = textField.text
            previousSelection = textField.selectedTextRange
        default:
            break
        }
        return true
    }

    //MARK: Card number formatting

    open func reformatAsCardNumber(_ textField: UITextField) {
        // In order to make the cursor end up positioned correctly, we need to
        // explicitly reposition it after we inject spaces into the text.
        // targetCursorPosition keeps track of where the cursor needs to end up as
        // we modify the string, and at the end we set the cursor position to it.
        guard let selectedRange = textField.selectedTextRange, let textString = textField.text else { return }
        var targetCursorPosition = textField.offset(from: textField.beginningOfDocument, to: selectedRange.start)

        let cardNumberWithoutSpaces = removeNonDigits(textString, cursorPosition: &targetCursorPosition)

        if cardNumberWithoutSpaces.count > ccrow.maxCreditCardNumberLength {
            // If the user is trying to enter more than maxCreditCardNumberLength digits, we prevent
            // their change, leaving the text field in its previous state.
            textField.text = previousTextFieldContent
            textField.selectedTextRange = previousSelection
            return
        }

        let cardNumberWithSpaces = insertSpacesEveryFourDigits(cardNumberWithoutSpaces, cursorPosition: &targetCursorPosition)

        // update text and cursor appropiately
        textField.text = cardNumberWithSpaces
        if let targetPosition = textField.position(from: textField.beginningOfDocument, offset: targetCursorPosition) {
            textField.selectedTextRange = textField.textRange(from: targetPosition, to: targetPosition)
        }
    }

    /**
     Removes non-digits from the string, decrementing `cursorPosition` as
     appropriate so that, for instance, if we pass in `@"1111 1123 1111"`
     and a cursor position of `8`, the cursor position will be changed to
     `7` (keeping it between the '2' and the '3' after the spaces are removed).
     */

    open func removeNonDigits(_ string: String, cursorPosition: inout Int) -> String {
        let originalCursorPosition = cursorPosition
        var digitsOnlyString = ""
        for i in 0..<string.count {
            let characterToAdd = string[string.index(string.startIndex, offsetBy: i)]
            if "0"..."9" ~= characterToAdd {
                digitsOnlyString.append(characterToAdd)
            }
            else {
                if (i < originalCursorPosition) {
                    cursorPosition -= 1
                }
            }
        }
        
        return digitsOnlyString

    }

    /**
     Inserts spaces into the string to format it as a credit card number,
     incrementing `cursorPosition` as appropriate so that, for instance, if we
     pass in `@"111111231111"` and a cursor position of `7`, the cursor position
     will be changed to `8` (keeping it between the '2' and the '3' after the
     spaces are added).
     */
    open func insertSpacesEveryFourDigits(_ string: String, cursorPosition: inout Int) -> String {
        var stringWithAddedSpaces = ""
        let cursorPositionInSpacelessString = cursorPosition
        for i in 0..<string.count {
            if ((i>0) && ((i % 4) == 0)) {
                stringWithAddedSpaces += ccrow.numberSeparator
                if (i < cursorPositionInSpacelessString) {
                    cursorPosition += ccrow.numberSeparator.count
                }
            }
            stringWithAddedSpaces.append(string[string.index(string.startIndex, offsetBy: i)])
        }
        
        return stringWithAddedSpaces
    }

    //MARK: Expiration date formatting
    open func reformatAsExpiration(_ textField: UITextField) {
        guard let string = textField.text else { return }
        let expirationString = String(ccrow.expirationSeparator)
        let cleanString = string.replacingOccurrences(of: expirationString, with: "", options: .literal, range: nil)
        if cleanString.count >= 3 {
            let monthString = cleanString[Range(0...1)]
            var yearString: String
            if cleanString.count == 3 {
                yearString = cleanString[2]
            } else {
                yearString = cleanString[Range(2...3)]
            }
            textField.text = monthString + expirationString + yearString
        } else {
            textField.text = cleanString
        }
    }

    //MARK: CVV formatting
    open func reformatAsCVV(_ textField: UITextField) {
        guard let string = textField.text else { return }
        if string.count > ccrow.maxCVVLength {
            textField.text = string[0..<ccrow.maxCVVLength]
        }
    }
}
