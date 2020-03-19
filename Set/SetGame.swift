//
//  Set.swift
//  Set
//
//  Created by Lewis Kim on 2020-01-15.
//  Copyright © 2020 Lewis Kim. All rights reserved.
//

import Foundation

struct SetGame {
    
    var cards = [Card]()
    var selectedCards = [Card]()
    var duplicates = [(Int, Int, Int, Int)]()
    var deckCards = 81
    var points = 0
    
    // Adds cards when add cards button is pressed.
    mutating func addCards() -> [IndexPath] {
        var indexesOfSelectedCards = [IndexPath]()
        if selectedCards.count == 3 {
            if selectedCards[0].isMatched {
                for i in selectedCards.indices {
                    if let cardIndex = cards.firstIndex(of: selectedCards[i]) {
                        cards[cardIndex].isSelected = false
                        cards[cardIndex].isMatched = false
                        deckCards -= 3
                        points += 1
                        let indexPath = IndexPath(row: cardIndex, section: 0)
                        indexesOfSelectedCards += [indexPath]
                    }
                }
            } else {
                for i in selectedCards.indices {
                    if let cardIndex = cards.firstIndex(of: selectedCards[i]) {
                        cards[cardIndex].isSelected = false
                    }
                }
            }
            selectedCards.removeAll()
        }
        return indexesOfSelectedCards
    }
    
    mutating func removeCard(index: Int) {
        cards.remove(at: index)
    }
    
    mutating func addThreeCards() {
        for _ in 0...2 {
            var card = Card()
            card.isFaceUp = true
            cards += [card]
            deckCards -= 1
        }
    }
    
    // Adds or removes cards when one card is selected.
    mutating func chooseCard(at index: Int) -> [IndexPath] {
        var indexesOfSelectedCards = [IndexPath]()
        if (cards[index].isSelected) {
            cards[index].isSelected = false
            if let index = selectedCards.firstIndex(of: cards[index]) {
                for index in selectedCards.indices {
                    if let cardIndex = cards.firstIndex(of: selectedCards[index]) {
                        selectedCards[index].isMatched = false
                        cards[cardIndex].isMatched = false
                    }
                }
                selectedCards.remove(at: index)
            }
        } else {
            if (!cards[index].isMatched) {
                cards[index].isSelected = true
                
                if selectedCards.count <= 1 {
                    selectedCards.append(cards[index])
                    
                } else if selectedCards.count == 2 {
                    
                    selectedCards.append(cards[index])
                    var allMatched = false
                    var allDifferent = false
                    for index in 0..<selectedCards[0].propertyIndex.count {
                        if (selectedCards[0].propertyIndex[index] == selectedCards[1].propertyIndex[index] && selectedCards[1].propertyIndex[index] == selectedCards[2].propertyIndex[index]) {
                            allMatched = true
                        } else if (selectedCards[0].propertyIndex[index] != selectedCards[1].propertyIndex[index] && selectedCards[1].propertyIndex[index] != selectedCards[2].propertyIndex[index] && selectedCards[0].propertyIndex[index] != selectedCards[2].propertyIndex[index]) {
                            allDifferent = true
                        } else {
                            allMatched = false
                            allDifferent = false
                            break
                        }
                    }
                    if (allMatched && allDifferent) || (!allMatched && allDifferent) {
                        for index in selectedCards.indices {
                            if let cardIndex = cards.firstIndex(of: selectedCards[index]) {
                                selectedCards[index].isMatched = true
                                cards[cardIndex].isMatched = true
                            }
                        }
                    }
                } else {
                    cards[index].isSelected = true
                    let tempCard = cards[index]
                    indexesOfSelectedCards = addCards()
                    selectedCards.append(tempCard)
                }
            }
        }
        return indexesOfSelectedCards
    }
    
    mutating func start() {
        for _ in 0...11 {
            var card = Card()
            card.isFaceUp = true
            cards += [card]
        }
    }
}
