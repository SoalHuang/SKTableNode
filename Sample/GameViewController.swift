//
//  GameViewController.swift
//  Sample
//
//  Created by soal on 25/05/2018.
//  Copyright © 2018 soso. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            if let sc = scene {
                view.presentScene(sc)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    private lazy var scene: SKScene? = {
        let sc = SKScene(fileNamed: "GameScene")
        sc?.scaleMode = .aspectFill
        return sc
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scene?.size = view.bounds.size
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
