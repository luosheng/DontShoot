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
    
    let view: SKView
    var scene: BarrageScene!
    
    public init() {
        view = SKView()
        
        view.allowsTransparency = true
        view.showsFPS = true
        view.showsNodeCount = true
        view.showsDrawCount = true
        view.backgroundColor = SKColor.clearColor()
    }
    
    public func renderInView(hostView: UIView) {
        view.frame = hostView.bounds
        hostView.addSubview(view)
        
        scene = BarrageScene(size: view.bounds.size)
        view.presentScene(scene)
        scene.backgroundColor = SKColor.clearColor()
        scene.scaleMode = .AspectFit
    }
    
    public func fire(text: String) {
        let node = BarrageNode(text: text)
        node.fontColor = SKColor.blackColor()
        node.fontSize = 20
        
        let frame = node.calculateAccumulatedFrame()
        node.position = CGPoint(x: CGRectGetMaxX(view.frame) + CGRectGetWidth(frame) / 2 , y: 0)
        scene.addChild(node)
        
        animate(node)
    }
    
    private func animate(node: BarrageNode) {
        let moveLeft = SKAction.moveByX(-(CGRectGetWidth(view.frame) + CGRectGetWidth(node.frame)), y: 0, duration: 3)
        node.runAction(moveLeft) { [weak node] in
            node?.removeFromParent()
        }
    }
    
}
