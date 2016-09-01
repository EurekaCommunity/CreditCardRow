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
        cellProvider = CellProvider<CreditCardCell>(nibName: "CreditCardCell", bundle: NSBundle(forClass: CreditCardRow.self))
    }
}
