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
        
        let scene = BarrageScene(size: spriteView.bounds.size)
        spriteView.presentScene(scene)
        scene.backgroundColor = SKColor.clearColor()
        scene.scaleMode = .AspectFit
    }
    
}
