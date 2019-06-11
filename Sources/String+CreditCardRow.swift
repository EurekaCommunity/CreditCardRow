//
//  String+CreditCardRow.swift
//  CreditCardRow
//
//  Created by Mathias Claassen on 9/5/16.
//
//

import Foundation

public extension String {

    subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }

    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }

    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(start, offsetBy: r.upperBound - r.lowerBound)
        return String(self[start..<end])
    }

}

//"abcde"[0] == "a"
//"abcde"[0...2] == "abc"
//"abcde"[2..<4] == "cd"
