//
//  ViewController.swift
//  Example
//
//  Copyright © 2016 Xmartlabs SRL. All rights reserved.
//

import UIKit
import Eureka
import CreditCardRow

class ViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        CreditCardRow.defaultRowInitializer = {
//            $0.cellProvider = CellProvider<CreditCardCell>(nibName: "CustomCell", bundle: nil)
//        }

        // Append the default CreditCardRow and my custom MyCreditCardRow
        form +++ Section()
            <<< CreditCardRow() {
                $0.numberSeparator = "-"
                $0.expirationSeparator = "-"
                $0.maxCreditCardNumberLength = 16
                $0.maxCVVLength = 3
            }

        +++ Section()
            <<< MyCreditCardRow() {
                    $0.numberSeparator = " - "
                }
                .cellSetup({ (cell, row) in
                    cell.height = { 50 }
                    cell.numberField.padding = 8
                    cell.numberField.textAlignment = .center
                    cell.numberField.textColor = .blue
                    cell.backgroundColor = UIColor(red: 0.83, green: 0.96, blue: 0.83, alpha: 1)
                })

    }
}

