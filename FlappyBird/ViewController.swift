//
//  ViewController.swift
//  FlappyBird
//
//  Created by admin on 2020/8/8.
//  Copyright © 2020 NealCoder. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import Log

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let view = self.view as! SKView? {
            
            let scene = GameScene.init(size: UIScreen.main.bounds.size)
            scene.scaleMode = .aspectFill
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            
        } else {
            Log.Error("SKView Init Failed")
        }
        
    }


}

