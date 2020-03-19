//
//  Card.swift
//  Set
//
//  Created by Lewis Kim on 2020-01-15.
//  Copyright © 2020 Lewis Kim. All rights reserved.
//

import Foundation

struct Card: Hashable {
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier && lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.identifier)
    }
    
    var isFaceUp = false
    var isMatched = false
    var isSelected = false
    var identifier: Int
    
    var propertyIndex = [Int]()
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}
