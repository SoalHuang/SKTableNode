//
//  GameScene.swift
//  Sample
//
//  Created by soal on 25/05/2018.
//  Copyright © 2018 soso. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        let tableNode = SKTableNode(size: CGSize(width: 300, height: 300), target: view)
        tableNode.backgroundNode.color = UIColor.blue
        
        tableNode.tableDataSource = self
        tableNode.tableDelegate = self
        
        tableNode.register(SKTableNodeTitleCell.self, forCellWithReuseIdentifier: "cell")
        
        addChild(tableNode)
    }
}

extension GameScene: SKTableNodeDataSource {
    
    func numberOfRows(in tableNode: SKTableNode) -> Int {
        return 100
    }
    
    func tableNode(_ tableNode: SKTableNode, cellForRowAt index: Int) -> SKTableNodeCell {
        let cell = tableNode.dequeueReusableCell(withReuseIdentifier: "cell") as! SKTableNodeTitleCell
        cell.color = index % 2 == 0 ? UIColor.red : UIColor.blue
        cell.labelNode.text = "\(index)"
        return cell
    }
}

extension GameScene: SKTableNodeDelegate {
    func tableNode(_ tableNode: SKTableNode, heightForRowAt index: Int) -> CGFloat {
        return 60
    }
}
