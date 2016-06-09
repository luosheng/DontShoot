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
    
    let spriteView: SKView
    var scene: BarrageScene!
    
    public init() {
        spriteView = SKView()
        
        spriteView.allowsTransparency = true
        spriteView.showsFPS = true
        spriteView.showsNodeCount = true
        spriteView.showsDrawCount = true
        spriteView.backgroundColor = SKColor.clearColor()
    }
    
    public func renderInView(view: UIView) {
        spriteView.frame = view.bounds
        view.addSubview(spriteView)
        
        scene = BarrageScene(size: spriteView.bounds.size)
        spriteView.presentScene(scene)
        scene.backgroundColor = SKColor.clearColor()
        scene.scaleMode = .AspectFit
    }
    
    public func fire(text: String) {
        let node = BarrageNode(text: text)
        node.fontColor = SKColor.blackColor()
        node.fontSize = 20
        
        let frame = node.calculateAccumulatedFrame()
        node.position = CGPoint(x: CGRectGetMaxX(spriteView.frame) + CGRectGetWidth(frame) / 2 , y: 0)
        scene.addChild(node)
        
        animate(node)
    }
    
    private func animate(node: BarrageNode) {
        let moveLeft = SKAction.moveByX(-(CGRectGetWidth(spriteView.frame) + CGRectGetWidth(node.frame)), y: 0, duration: 2)
        node.runAction(moveLeft) { [weak node] in
            node?.removeFromParent()
        }
    }
    
}
