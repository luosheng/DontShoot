//
//  BarrageController.swift
//  DontShoot
//
//  Created by Luo Sheng on 16/6/8.
//  Copyright © 2016年 Luo Sheng. All rights reserved.
//

import Foundation
import SpriteKit

public class BarrageController {
    
    struct Constants {
        static let lineKey = "Line"
        static let randomSpeedLowerBound: Float = 0.9
        static let randomSpeedUpperBound: Float = 1.1
    }
    
    let view: SKView
    
    var scene: BarrageScene!
    
    public var speed: CGFloat = 80
    
    public var lineSpacing: CGFloat = 5
    
    public var fontSize: CGFloat = 20
    
    public var bulletMargin: CGFloat = 20
    
    private var maximumLines: Int = 0
    
    private var lineMapping: [Int: [BarrageNode]] = [:]
    
    public init() {
        view = SKView()
        
        view.allowsTransparency = true
        view.backgroundColor = SKColor.clearColor()
        #if DEBUG
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsDrawCount = true
        #endif
    }
    
    public func renderInView(hostView: UIView) {
        view.frame = hostView.bounds
        hostView.addSubview(view)
        
        scene = BarrageScene(size: view.bounds.size)
        view.presentScene(scene)
        scene.backgroundColor = SKColor.clearColor()
        scene.scaleMode = .AspectFit
        
        maximumLines = Int(CGRectGetHeight(view.frame) / (fontSize + lineSpacing))
    }
    
    public func fire(text: String) {
        let node = BarrageNode(text: text)
        node.fontColor = SKColor.blackColor()
        node.fontSize = fontSize
        
        let frame = node.calculateAccumulatedFrame()
        
        let line = findNextLine()
        let y = CGRectGetHeight(view.frame) - (CGRectGetHeight(frame) + lineSpacing) * CGFloat(line)
        
        node.position = CGPoint(x: CGRectGetMaxX(view.frame) + CGRectGetWidth(frame) / 2 , y: y)
        addNode(node, toLine: line)
        scene.addChild(node)
        
        animate(node)
    }
    
    private func animate(node: BarrageNode) {
        let duration = CGRectGetWidth(view.frame) / speed
        let moveLeft = SKAction.moveByX(-(CGRectGetWidth(view.frame) + CGRectGetWidth(node.frame)), y: 0, duration: NSTimeInterval(duration))
        node.speed = CGFloat(randomFloatBetween(lowerBound: Constants.randomSpeedLowerBound, upperBound: Constants.randomSpeedUpperBound))
        node.runAction(moveLeft) { [weak node] in
            guard let node = node else {
                return
            }
            node.removeFromParent()
            self.removeNodeFromLine(node)
        }
    }
    
    private func findNextLine() -> Int {
        // Find pairs of each line and its max X for nodes inside that line
        let linesWithMaxX = lineMapping.map { (line, nodes) -> (Int, CGFloat) in
            let maxY = nodes.reduce(CGFloat.min) { max($0, CGRectGetMaxX($1.frame)) }
            return (line, maxY)
        }
        
        let sortedByLine = linesWithMaxX.sort { $0.0 < $1.0 }
        
        let linesWithinBoundary = sortedByLine.filter { $0.1 + bulletMargin <= CGRectGetWidth(view.frame) }
        if linesWithinBoundary.count > 0 {
            // Exisiting lines have enough space to fit in another bullet
            return linesWithinBoundary.first!.0
        } else if let lastLine = sortedByLine.last?.0 {
            if lastLine < maximumLines {
                // Try to put the bullet to the next line of the current last one
                return lastLine + 1
            } else {
                // We have to overlap a line, but we can do it with the least cost
                let sortedByX = linesWithMaxX.sort { $0.1 < $1.1 }
                return sortedByX.first?.0 ?? 1
            }
        } else {
            // Nothing on the screen? Put it on the first line
            return 1
        }
    }
    
    private func addNode(node: BarrageNode, toLine line: Int) {
        if lineMapping[line] == nil {
            lineMapping[line] = []
        }
        
        node.userData = [Constants.lineKey: line]
        lineMapping[line]?.append(node)
    }
    
    private func removeNodeFromLine(node: BarrageNode) {
        guard let line = node.userData?[Constants.lineKey] as? Int else {
            return
        }
        
        if let index = lineMapping[line]?.indexOf(node) {
            lineMapping[line]?.removeAtIndex(index)
        }
    }
    
    private func randomFloatBetween(lowerBound lowerBound: Float, upperBound: Float) -> Float {
        let diff = upperBound - lowerBound
        return Float(Float(arc4random()) / Float(UINT32_MAX)) * diff + lowerBound
    }
    
}
