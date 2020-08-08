//
//  GameScene.swift
//  FlappyBird
//
//  Created by admin on 2020/8/8.
//  Copyright © 2020 NealCoder. All rights reserved.
//

import Foundation

import SpriteKit



let birdCategory: UInt32 = 0x1 << 0

let pipeCategory: UInt32 = 0x1 << 1

let floorCategory: UInt32 = 0x1 << 2

class GameScene: SKScene {
    
    var floor1: SKSpriteNode!
    var floor2: SKSpriteNode!
    
    var bird: SKSpriteNode!
    
    var gameStatus: GameStatus = .idle
    
    var birdSpeed: CGFloat = 2.0
    
    var pipCount: Int = 3
    
    override func didMove(to view: SKView) {
        
        
        SpritConfig()
        GameInit()
        
    
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if self.bird.position.x < 0 {
            self.GameOver()
        }
    
        switch self.gameStatus {
        case .idle:
            break
        case .running:
            FloorMove()
            movePipe()
            break
        case .end:
            
            break

        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if gameStatus == .idle {
            self.GameStart()
        } else if gameStatus == .running {
  
            if bird.physicsBody?.velocity.dy ?? 0 > 100.0 {
                return
            }
            bird.physicsBody?.applyImpulse(CGVector.init(dx: 0, dy: 20))
            if bird.physicsBody?.velocity.dy ?? 0 > 520.0 {
                bird.physicsBody?.velocity.dy = 520.0
            }
            
//            if bird.physicsBody?.velocity.dx ?? 0 != 0 {
//                bird.physicsBody?.velocity.dx = 0
//            }
            
            
        } else if gameStatus == .end {
            self.GameStart()
        }
        
    }
    
    
}


//MARK:- SpritConfig
extension GameScene {
    
    func SpritConfig() {
        
    
        backgroundColor = SKColor.init(red: 80/255.0, green: 110/155.0, blue: 203/255.0, alpha: 1)
        
        floor1 = SKSpriteNode.init(imageNamed: "floor")
        floor2 = SKSpriteNode.init(imageNamed: "floor")
        
        floor1.anchorPoint = CGPoint.init(x: 0, y: 0)
        floor1.position = CGPoint.init(x: 0, y: 0)
        addChild(floor1)
        
        floor2.anchorPoint = CGPoint.init(x: 0, y: 0)
        floor2.position = CGPoint.init(x: floor1.size.width, y: 0)
        addChild(floor2)
        
        bird = SKSpriteNode.init(imageNamed: "player1")
        bird.anchorPoint = CGPoint.init(x: 0.5, y: 0.5)
        addChild(bird)
        
        SpritPhysicsConfig()
        BirdFly()
        
        
    }
    
    func SpritPhysicsConfig() {
        
        
        floor1.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: -10, width: floor1.size.width, height: floor1.size.height))
        floor1.physicsBody?.categoryBitMask = floorCategory
        
        floor2.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: -10, width: floor2.size.width, height: floor2.size.height))
        floor2.physicsBody?.categoryBitMask = floorCategory
        
        bird.physicsBody = SKPhysicsBody.init(texture: bird.texture!, size: bird.size)
        bird.physicsBody?.categoryBitMask = birdCategory
        bird.physicsBody?.restitution = self.physicsWorld.gravity.dy
        bird.physicsBody?.allowsRotation = false
        
    }
    
    func BirdFly() {
        let flyAction = SKAction.animate(with: [SKTexture.init(imageNamed: "player1"),
                                                SKTexture.init(imageNamed: "player2"),
                                                SKTexture.init(imageNamed: "player3"),
                                                SKTexture.init(imageNamed: "player2"),
                                                ],
                                         timePerFrame: 0.1)
//        let
        bird.run(SKAction.repeatForever(flyAction), withKey: "bird fly action")
    }
    
    func BirdFlyStop() {
        bird.removeAction(forKey: "bird fly action")
        
    }
    
    func FloorMove() {
        floor1.position = CGPoint.init(x: floor1.position.x - birdSpeed, y: floor1.position.y)
        floor2.position = CGPoint.init(x: floor2.position.x - birdSpeed, y: floor1.position.y)
        
        if floor1.position.x <= -floor1.size.width + 0.5 {
            floor1.position.x = floor1.size.width
        }
        if floor2.position.x <= -floor2.size.width + 0.5 {
            floor2.position.x = floor2.size.width
        }
        
    }
    
    
}

//MARK:- pipeConfig
extension GameScene {
    
    /**
     *
     * @param center - center of gap on screen from 0 to 1
     * @param height - height of gap on screen
     */
    func addPipe(center: CGFloat, height: CGFloat) {
        let topTexture = SKTexture.init(imageNamed: "topPipe")
        let bottomTexture = SKTexture.init(imageNamed: "bottomPipe")
        
        let hb = size.height * center - height/2.0
        let ht = size.height - height - hb
        
        let topSize = CGSize.init(width: 90, height: ht)
        let bottomSize = CGSize.init(width: 90, height: hb)
        
        let topPipe = SKSpriteNode.init(texture: topTexture, size: topSize)
        topPipe.position = CGPoint.init(x: size.width + topSize.width/2.0, y: size.height - topPipe.size.height/2.0)
        topPipe.physicsBody = SKPhysicsBody.init(texture: topTexture, size: topSize)
        topPipe.physicsBody?.categoryBitMask = pipeCategory
        topPipe.physicsBody?.affectedByGravity = false
        topPipe.physicsBody?.isDynamic = false
        topPipe.name = "pipe"
        addChild(topPipe)
        
        let bottomPipe = SKSpriteNode.init(texture: bottomTexture, size: bottomSize)
        bottomPipe.position = CGPoint.init(x: size.width + bottomSize.width/2.0, y: bottomSize.height/2.0)
        bottomPipe.physicsBody = SKPhysicsBody.init(texture: bottomTexture, size: bottomSize)
        bottomPipe.physicsBody?.categoryBitMask = pipeCategory
        bottomPipe.physicsBody?.affectedByGravity = false
        bottomPipe.physicsBody?.isDynamic = false
        bottomPipe.name = "pipe"
        addChild(bottomPipe)
        
        
        
    }
    
    func startCreateRandomPipesAction() {
        let waitAct = SKAction.wait(forDuration: 3.5, withRange: 1)

        let generatePipeAct = SKAction.run {
            let height:CGFloat = CGFloat(arc4random_uniform(100) + 120);
            self.addPipe(center: CGFloat(arc4random_uniform(50)) / 100.0 + height/self.frame.size.height, height: height)
        }
        
        run(SKAction.repeatForever(SKAction.sequence([waitAct, generatePipeAct])), withKey: "createPipe")
    }
    
    func movePipe() {
        for pipe in self.children where pipe.name == "pipe" {
            pipe.position = CGPoint.init(x: pipe.position.x - birdSpeed, y: pipe.position.y)
            if pipe.position.x + pipe.frame.size.width / 2.0 < 0 {
                pipe.removeFromParent()
            }
        }
    }
    
    func stopCreateRandomPipesAction() {
        removeAction(forKey: "createPipe")
    }
    
    func removeAllPipes() {
        for pipe in self.children where pipe.name == "pipe" {
            pipe.removeFromParent()
        }
    }
    
}


//MARK:- GameStateConfig
extension GameScene {
    enum GameStatus {
        case idle
        case running
        case end
    }
    
    func GameInit() {
        self.gameStatus = .idle
        
        bird.position = CGPoint.init(x: 100, y: self.size.height / 2.0)
        bird.physicsBody?.isDynamic = false
    }
    
    func GameStart() {
        self.BirdFly()
        bird.position = CGPoint.init(x: 100, y: self.size.height / 2.0)
        self.gameStatus = .running
        bird.physicsBody?.isDynamic = true
        self.removeAllPipes()
        self.startCreateRandomPipesAction()
    }
    
    func GameOver() {
        
        self.gameStatus = .end
        self.BirdFlyStop()
//        bird.physicsBody?.isDynamic = false
        self.stopCreateRandomPipesAction()
//
    }
    
    
}


