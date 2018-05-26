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
    
    deinit {
        print("GameScene deinit")
    }
    
    override func didMove(to view: SKView) {
        setupTableNode(view: view)
        tableNode?.didMove(to: view)
    }
    
    override func willMove(from view: SKView) {
        tableNode?.willMove(from: view)
    }
    
    private func setupTableNode(view: SKView) {
        if tableNode?.parent != nil {
            return
        }
        if let table = tableNode {
            addChild(table)
            return
        }
        tableNode = SKTableNode(size: size, target: view, scene: self)
        
        tableNode!.backgroundNode.color = .blue
        
        tableNode!.tableDataSource = self
        tableNode!.tableDelegate = self
        
        tableNode!.register(SampleCell.self, forCellWithReuseIdentifier: "cell")
        
        addChild(tableNode!)
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
    
    func tableNode(_ tableNode: SKTableNode, didSelectRowAt index: Int) {
        tableNode.deselectRow(at: index, animated: true)
        
        let detailScene = DetailScene(size: size)
        detailScene.index = index
        detailScene.lastScene = self
        view?.presentScene(detailScene)
    }
}
