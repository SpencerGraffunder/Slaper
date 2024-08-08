//
//  GameScene.swift
//  Slaper
//
//  Created by Spencer Graffunder on 8/8/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // Constant sizing
    var platformWidth: CGFloat = 0
    var playerWidth: CGFloat = 0
    var arrowWidth: CGFloat = 0
    
    // Sprites
    var platform1: SKSpriteNode!
    var platform2: SKSpriteNode!
    var player: SKSpriteNode!
    var arrow: SKSpriteNode!
    
    // Physics
    var isArrowFilling = false
    var arrowFillProgress: CGFloat = 0.0
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        let framew = frame.width
        platformWidth = 250 * 0.0013 * framew
        playerWidth = 14 * 0.06 * framew
        arrowWidth = 32 * 0.04 * framew
        
        // Set up background
        backgroundColor = UIColor(red: 100/255.0, green: 149/255.0, blue: 237/255.0, alpha: 1.0) // Cornflower blue
        
        var platforms: [SKSpriteNode] = []
        platforms.append(createPlatform(startingPlatform: true))
        platforms.append(createPlatform())
        
        // Create player character
        player = SKSpriteNode(imageNamed: "blocky")
        player.texture?.filteringMode = .nearest
        player.xScale = playerWidth / player.size.width
        player.position = CGPoint(x: platforms[0].position.x, y: platforms[0].position.y + (player.size.height / 2) + 10)
        addChild(player)
        
        // Create arrow
        arrow = SKSpriteNode(imageNamed: "arrow")
        arrow.scale(to: CGSize(width: 75, height: 125))
        arrow.position = CGPoint(x: player.position.x, y: player.position.y + player.size.height + (arrow.size.height / 2) + 10)
        addChild(arrow)
        
        // Set up physics
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.isDynamic = false
        
        platforms.forEach { platform in
            addChild(platform)
        }
                
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.isDynamic = true
        player.physicsBody?.allowsRotation = false
        
        // Set up touch handling
        view.isMultipleTouchEnabled = true
    }
    
    func createPlatform(startingPlatform: Bool = false) -> SKSpriteNode {
        let platform = SKSpriteNode(imageNamed: "platform")
        platform.xScale = platformWidth / platform.size.width
        platform.scale(to: CGSize(width: 125, height: 50))
        platform.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        let framew = frame.width
        let xPos = startingPlatform ? framew / 2 : CGFloat.random(in: (platformWidth/2)...(frame.width - (platformWidth/2)))
        let yPos = startingPlatform ? frame.minY + (frame.height * 0.125) : frame.minY + (frame.height * 0.5)
        platform.position = CGPoint(x: xPos, y: yPos)
        platform.physicsBody = SKPhysicsBody(rectangleOf: platform.size)
        platform.physicsBody?.isDynamic = false
        return platform
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        // Stop arrow rotation
        arrow.removeAllActions()
        
        // Start filling arrow
        isArrowFilling = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        // Move Blocky up
        moveBlockyUp()
        
        // Reset arrow filling
        isArrowFilling = false
        arrowFillProgress = 0.0
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        // Rotate arrow back and forth around the center of Blocky
        arrow.position = CGPoint(x: player.position.x, y: player.position.y + player.size.height + (arrow.size.height / 2) + 10)
        arrow.anchorPoint = player.position
        arrow.zRotation = CGFloat(sin(currentTime * 2) * 0.5)
        
        // Fill arrow if tapped
        if isArrowFilling {
            arrowFillProgress += 0.01
            if arrowFillProgress >= 1.0 {
                arrowFillProgress = 1.0
                isArrowFilling = false
            }
            arrow.texture?.filteringMode = .nearest
            //arrow.texture?.draw(in: CGRect(x: 0, y: 0, width: arrow.size.width, height: arrow.size.height * arrowFillProgress))
        } else {
            arrowFillProgress = max(arrowFillProgress - 0.01, 0.0)
            arrow.texture?.filteringMode = .nearest
            //arrow.texture?.draw(in: CGRect(x: 0, y: 0, width: arrow.size.width, height: arrow.size.height * arrowFillProgress))
        }
    }
    
    func moveBlockyUp() {
        // Implement your physics-based Blocky movement here
        print("Moving Blocky up!")
    }
}
