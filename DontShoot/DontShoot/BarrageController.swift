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
        // Move at the speed of 100 dp/sec
        static let speed: Float = 80
    }
    
    let view: SKView
    var scene: BarrageScene!
    
    public var lineSpacing: CGFloat = 5
    
    public var fontSize: CGFloat = 20
    
    private var maximumLines: Int = 0
    
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
        node.position = CGPoint(x: CGRectGetMaxX(view.frame) + CGRectGetWidth(frame) / 2 , y: 0)
        scene.addChild(node)
        
        animate(node)
    }
    
    private func animate(node: BarrageNode) {
        let duration = Float(CGRectGetWidth(view.frame)) / Constants.speed
        let moveLeft = SKAction.moveByX(-(CGRectGetWidth(view.frame) + CGRectGetWidth(node.frame)), y: 0, duration: NSTimeInterval(duration))
        let speed = randomFloatBetween(lowerBound: 0.9, upperBound: 1.1)
        node.speed = CGFloat(speed)
        node.runAction(moveLeft) { [weak node] in
            node?.removeFromParent()
        }
    }
    
    private func randomFloatBetween(lowerBound lowerBound: Float, upperBound: Float) -> Float {
        let diff = upperBound - lowerBound
        return Float(Float(arc4random()) / Float(UINT32_MAX)) * diff + lowerBound
    }
    
}
