//
//  CreditCardRow.swift
//  CreditCardRow
//
//  Created by Mathias Claassen on 9/1/16.
//
//

import Eureka

/// Credit card row for Eureka. If you want to change the nib file for this cell then you should subclass _CreditCardRow
public class _CreditCardRow : Row<CreditCardInfo, CreditCardCell> {

    /// Separator for the credit card number. Defaults to a whitespace. Emojis currently not supported.
    public var numberSeparator: String = " "

    /// Separator used between month and year numbers in expiration field
    public var expirationSeparator: Character = "/"

    /// Maximum length for CVV number
    public var maxCVVLength: Int = 4

    /// Maximum length for Credit Card number. Credit Card length can be up to 19 after ISO 7812-1. 6 digits IIN, 12 account digits and a check digit.
    public var maxCreditCardNumberLength = 19
    
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
        value = CreditCardInfo()
    }
}

/// Credit card row for Eureka.
public final class CreditCardRow : _CreditCardRow, RowType {

    required public init(tag: String?) {
        super.init(tag: tag)

        // load correct bundle for cell nib file
        var bundle: NSBundle
        if let bundleWithIdentifier = NSBundle(identifier: "com.xmartlabs.CreditCardRow") {
            // Example or Carthage
            bundle = bundleWithIdentifier
        } else {
            // Cocoapods
            let podBundle = NSBundle(forClass: CreditCardRow.self)
            let bundleURL = podBundle.URLForResource("Frameworks/CreditCardRow.framework/CreditCardRow", withExtension: "bundle")
            bundle = NSBundle(URL: bundleURL!)!
        }
        cellProvider = CellProvider<CreditCardCell>(nibName: "CreditCardCell", bundle: bundle)
    }


}
