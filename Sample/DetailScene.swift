//
//  DetailScene.swift
//  Sample
//
//  Created by soal on 26/05/2018.
//  Copyright © 2018 soso. All rights reserved.
//

import SpriteKit

class DetailScene: SKScene {
    
    var index: Int = 0
    
    weak var lastScene: SKScene?
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor.lightGray
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let label = SKLabelNode()
        label.text = "index: \(index), touch to exit"
        addChild(label)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let ls = lastScene {
            view?.presentScene(ls)
        }
    }
    
}
