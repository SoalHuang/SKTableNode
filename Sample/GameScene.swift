//
//  GameScene.swift
//  Sample
//
//  Created by soal on 25/05/2018.
//  Copyright © 2018 soso. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var tableNode: SKTableNode?
    
    override func didMove(to view: SKView) {
        
        let table = SKTableNode(size: size, target: view)
        table.backgroundNode.color = .blue
        
        table.tableDataSource = self
        table.tableDelegate = self
        
        table.register(SampleCell.self, forCellWithReuseIdentifier: "cell")
        
        addChild(table)
        
        tableNode = table
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        tableNode?.size = size
    }
}

extension GameScene: SKTableNodeDataSource {
    
    func numberOfRows(in tableNode: SKTableNode) -> Int {
        return 100
    }
    
    func tableNode(_ tableNode: SKTableNode, cellForRowAt index: Int) -> SKTableNodeCell {
        let cell = tableNode.dequeueReusableCell(withReuseIdentifier: "cell") as! SampleCell
        cell.labelNode.text = "\(index)"
        return cell
    }
}

extension GameScene: SKTableNodeDelegate {
    func tableNode(_ tableNode: SKTableNode, heightForRowAt index: Int) -> CGFloat {
        return 60
    }
}
