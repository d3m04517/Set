//
//  ViewController.swift
//  Set
//
//  Created by Lewis Kim on 2020-01-15.
//  Copyright © 2020 Lewis Kim. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        game.start()
        setProperties()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    // Private Variables
    // Set colors, symbols, numbers, shading
    private let colors = ["red", "green", "purple"]
    private let symbols = ["oval", "diamond", "squiggle"]
    private let numbers = [1,2,3]
    private let shading = ["solid", "opened", "striped"]
    private var deckCount = 81 {
        didSet {
            deckLabel.text = "Deck: \(deckCount)"
        }
    }
    private var animationDelay = 0.0
    private var points = 0 {
        didSet {
            pointsLabel.text = "Points: \(self.points)"
        }
    }
    private lazy var game = SetGame()
    
    // Labels
    @IBOutlet weak var deckLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    // Collection View
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Collection view delegate functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return game.cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Get the cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        // Add tap gesture to cell
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleCellTap))
        cell.addGestureRecognizer(tap)
        deckCount = game.deckCards
        if game.cards[indexPath[1]].propertyIndex.count != 4 {
            setProperties()
        }
        
        // Set properties of cell
        cell.propertyIndex = game.cards[indexPath[1]].propertyIndex
        cell.numberOfShapes = numbers[game.cards[indexPath[1]].propertyIndex[2]]
        cell.color = colors[game.cards[indexPath[1]].propertyIndex[0]]
        cell.symbols = symbols[game.cards[indexPath[1]].propertyIndex[1]]
        cell.numbers = numbers[game.cards[indexPath[1]].propertyIndex[2]]
        cell.shading = shading[game.cards[indexPath[1]].propertyIndex[3]]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width * 0.25, height: collectionView.bounds.height * 0.08)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        drawCardsAnimation(cell: cell)
    }
    
    // Get location of tapped cell, update model, update view.
    @objc func handleCellTap(gesture: UITapGestureRecognizer!) {
        if gesture.state != .ended {
            return
        }
        
        let p = gesture.location(in: self.collectionView)
        
        // Get indexpath to get index of card selected
        if let indexPath = self.collectionView.indexPathForItem(at: p) {
            let indexesOfSelectedCards = game.chooseCard(at: indexPath[1])
            updateViewFromModel(indexPaths: indexesOfSelectedCards, buttonPressed: false)
        } else {
            print("Cant find index path")
        }
    }
    
    // Update view from the model.
    private func updateViewFromModel(indexPaths: [IndexPath], buttonPressed: Bool) {
        
        // Check if there are matched cards
        if (indexPaths.count == 3) {
            removeCards(indexPaths: indexPaths)
            points += 1
            if game.cards.count < 12 {
                addThreeCards()
            } else if buttonPressed {
                addThreeCards()
            }
        } else if buttonPressed, game.cards.count <= 20 {
            addThreeCards()
        }
        for index in 0..<game.cards.count {
            let indexPath = IndexPath(row: index, section: 0)
            let cell = collectionView.cellForItem(at: indexPath)!
            if game.cards[index].isSelected {
                cell.layer.borderWidth = 3.0
                cell.layer.borderColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
            } else {
                cell.layer.borderWidth = 0
                cell.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
            deckCount = game.deckCards
        }
    }
    
    // Add three cards into play
    private func addThreeCards() {
        var newIndexPaths = [IndexPath]()
        game.addThreeCards()
        for index in stride(from: 3, to: 0, by: -1) {
            newIndexPaths += [IndexPath(row: game.cards.count - index, section: 0)]
        }
        animationDelay = 0
        collectionView.insertItems(at: newIndexPaths)
        for indexPath in newIndexPaths {
            let cell = collectionView.cellForItem(at: indexPath)!
            drawCardsAnimation(cell: cell)
            
        }
        self.collectionView.reloadData()
    }
    
    // Animation when drawing cards
    private func drawCardsAnimation(cell: UICollectionViewCell) {
        let originLocationOfCell = cell.frame.origin
        let originLocationOfDeck = deckLabel.frame.origin
        
        cell.frame = CGRect(x: originLocationOfDeck.x, y: originLocationOfDeck.y, width: cell.frame.width, height: cell.frame.height)
        let xDistanceFromOrigin = originLocationOfDeck.x - originLocationOfCell.x
        let yDistanceFromOrigin = originLocationOfDeck.y - originLocationOfCell.y
        animationDelay += 0.2
        // Animation
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5,
                                                       delay: animationDelay,
                                                       options: [.curveEaseOut],
                                                       animations: {
                                                        cell.transform = CGAffineTransform(translationX: -xDistanceFromOrigin, y: -yDistanceFromOrigin) })
    }
    
    // Remove cards from play
    private func removeCards(indexPaths: [IndexPath]) {
        let animationDuration = 0.1
        for index in stride(from: indexPaths.count, to: 0, by: -1) {
            let indexPath = IndexPath(row: index, section: 0)
            game.removeCard(index:indexPath.row)
            UIView.animate(withDuration: animationDuration, animations: {self.collectionView.deleteItems(at: [indexPath])})
        }
    }

    @IBAction func addCardsButton(_ sender: Any) {
        let indexPaths = game.addCards()
        updateViewFromModel(indexPaths: indexPaths, buttonPressed: true)
    }
    
    // Sets a random shape,color,symbol for a card
    private func setProperties() {
        for index in game.cards.indices {
            
            var colorIndex = game.cards[index].propertyIndex.count != 4 ? Int.random(in: 0...2) : game.cards[index].propertyIndex[0]
            var symbolIndex = game.cards[index].propertyIndex.count != 4 ? Int.random(in: 0...2) : game.cards[index].propertyIndex[1]
            var numberIndex = game.cards[index].propertyIndex.count != 4 ? Int.random(in: 0...2) : game.cards[index].propertyIndex[2]
            var shadingIndex = game.cards[index].propertyIndex.count != 4 ? Int.random(in: 0...2) : game.cards[index].propertyIndex[3]
            while game.duplicates.contains(where: {($0, $1, $2, $3) == (colorIndex, symbolIndex, numberIndex, shadingIndex)}), game.cards[index].propertyIndex.count == 0 {
                colorIndex = Int.random(in: 0...2)
                symbolIndex = Int.random(in: 0...2)
                numberIndex = Int.random(in: 0...2)
                shadingIndex = Int.random(in: 0...2)
            }
            game.duplicates += [(colorIndex, symbolIndex, numberIndex, shadingIndex)]
            game.cards[index].propertyIndex = [colorIndex, symbolIndex, numberIndex, shadingIndex]
        }
    }
    
}

