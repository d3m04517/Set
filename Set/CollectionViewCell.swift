//
//  CollectionViewCell.swift
//  Set
//
//  Created by Lewis Kim on 2020-02-02.
//  Copyright © 2020 Lewis Kim. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    var propertyIndex = [Int]() {
        didSet {
            setNeedsDisplay()
        }
    }
    var numberOfShapes = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    var color = "red" {
        didSet {
            setNeedsDisplay()
        }
    }
    var symbols = "oval" {
        didSet {
            setNeedsDisplay()
        }
    }
    var numbers = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    var shading = "solid" {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        let widthOfShape = bounds.width / CGFloat(numberOfShapes)
        for index in 0..<numberOfShapes {
            drawShape(width: widthOfShape, index: index)
        }
    }
    
    private func drawShape(width: CGFloat, index: Int) {
        var shape = UIBezierPath()
        switch symbols {
        case "oval":
            shape = drawOval(width: width, index: index)
        case "diamond":
            shape = drawDiamond(width: width, index: index)
        case "squiggle":
            shape = drawSquiggle(width: width, index: index)
        default:
            break
        }
        fillShading(shape: shape, width: width)
    }
    
    private func fillShading(shape: UIBezierPath, width: CGFloat) {
        switch color {
        case "red":
            UIColor.red.setFill()
            UIColor.red.setStroke()
        case "purple":
            UIColor.purple.setFill()
            UIColor.purple.setStroke()
        case "green":
            UIColor.green.setFill()
            UIColor.green.setStroke()
        default:
            break
        }
        switch shading {
        case "solid":
            shape.fill()
            shape.stroke()
        case "opened":
            shape.stroke()
        case "striped":
            drawStripes(in: shape, within: bounds)
        default:
            break
        }
    }
    
    private func drawDiamond(width: CGFloat, index: Int) -> UIBezierPath {
        let diamond = UIBezierPath()
        
        let centerPoint = CGPoint(x: (width / 2) + (width * CGFloat(index)), y: bounds.midY)
        
        let rightCorner = CGPoint(x: centerPoint.x + SizeRatio.drawDistance + 5, y: bounds.midY)
        let topCorner = CGPoint(x: centerPoint.x, y: bounds.midY - SizeRatio.drawDistance - 5)
        let leftCorner = CGPoint(x: centerPoint.x - SizeRatio.drawDistance - 5, y: bounds.midY)
        let bottomCorner = CGPoint(x: centerPoint.x, y: bounds.midY + SizeRatio.drawDistance + 5)
        
        diamond.move(to: rightCorner)
        diamond.addLine(to: rightCorner)
        diamond.addLine(to: topCorner)
        diamond.addLine(to: leftCorner)
        diamond.addLine(to: bottomCorner)
        diamond.close()
        
        return diamond
    }
    
    private func drawOval(width: CGFloat, index: Int) -> UIBezierPath {
        let centerPoint = CGPoint(x: (width / 2) + (width * CGFloat(index)), y: bounds.midY)
        let oval = UIBezierPath(ovalIn: CGRect(x: centerPoint.x - 6, y: bounds.height / 5, width: SizeRatio.drawDistance * 2, height: (bounds.height / 2) + SizeRatio.drawDistance))
        return oval
    }
    
    private func drawSquiggle(width: CGFloat, index: Int) -> UIBezierPath {
        let squiggle = UIBezierPath()

        let centerPoint = CGPoint(x: (width / 2) + (width * CGFloat(index)), y: bounds.midY)
        
        let topRightPoint = CGPoint(x: centerPoint.x + SizeRatio.drawDistance, y: SizeRatio.inset)
        let bottomRightPoint = CGPoint(x: centerPoint.x + SizeRatio.drawDistance, y: bounds.height - SizeRatio.inset)
        let topLeftPoint = CGPoint(x: centerPoint.x - SizeRatio.drawDistance, y: SizeRatio.inset)
        let bottomLeftPoint = CGPoint(x: centerPoint.x - SizeRatio.drawDistance, y: bounds.height - SizeRatio.inset)
        
        squiggle.move(to: topRightPoint)
        squiggle.addLine(to: topLeftPoint)
        squiggle.addCurve(to: bottomLeftPoint, controlPoint1: CGPoint(x: topLeftPoint.x + SizeRatio.curveOffset, y: topLeftPoint.y + SizeRatio.curveOffset), controlPoint2: CGPoint(x: bottomLeftPoint.x - SizeRatio.curveOffset, y: bottomLeftPoint.y - SizeRatio.curveOffset))
        squiggle.addLine(to: bottomRightPoint)
        squiggle.addCurve(to: topRightPoint, controlPoint1: CGPoint(x: bottomRightPoint.x - SizeRatio.curveOffset, y: bottomRightPoint.y - SizeRatio.curveOffset), controlPoint2: CGPoint(x: topRightPoint.x + SizeRatio.curveOffset, y: topRightPoint.y + SizeRatio.curveOffset))
        return squiggle
    }
    
    private func drawStripes(in shapePath: UIBezierPath, within bounds: CGRect) {
        let yCoord = bounds.maxY
        let numStripes = Int(bounds.width / SizeRatio.stripeInterval)
        
        UIGraphicsGetCurrentContext()?.saveGState()
        shapePath.addClip()
        
        for x in 0..<numStripes {
            let xCoord = CGFloat(x)
            
            shapePath.move(to: CGPoint(x: xCoord * SizeRatio.stripeInterval, y: 0))
            shapePath.addLine(to: CGPoint(x: xCoord * SizeRatio.stripeInterval, y: yCoord))
        }
        
        shapePath.stroke()
        UIGraphicsGetCurrentContext()?.restoreGState()
    }
}

extension CollectionViewCell {
    struct SizeRatio {
        static let drawDistance: CGFloat = 6
        static let inset: CGFloat = 8
        static let curveOffset: CGFloat = 5
        static let stripeInterval: CGFloat = 3
    }
}
