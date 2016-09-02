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
        return self[self.startIndex.advancedBy(i)]
    }

    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }

    subscript (r: Range<Int>) -> String {
        let start = startIndex.advancedBy(r.startIndex)
        let end = start.advancedBy(r.endIndex - r.startIndex)
        return self[Range(start ..< end)]
    }

    var length: Int {
        return characters.count
    }
}

//"abcde"[0] == "a"
//"abcde"[0...2] == "abc"
//"abcde"[2..<4] == "cd"
