//
//  CustomRow.swift
//  Example
//
//  Created by Mathias Claassen on 9/5/16.
//
//

import Foundation
import CreditCardRow
import Eureka

final class MyCreditCardRow: _CreditCardRow, RowType {
    required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<CreditCardCell>(nibName: "CustomCell", bundle: Bundle.main)
    }
}
