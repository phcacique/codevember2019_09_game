//
//  GameScene.swift
//  Game
//
//  Created by Pedro Cacique on 09/11/19.
//  Copyright © 2019 Pedro Cacique. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    var world: World = World()
    var player: Player = Player()
    var score:Int = 0
    var joystick:Joystick = Joystick(width: 50)
    var activeTouches = [UITouch:String]()
    var hasJoystick:Bool = false
    var scorelabel:SKLabelNode = SKLabelNode(text: "0")
    
    var renderTime: TimeInterval = 0
    let spawnItem: TimeInterval = 1
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor.gameTheme.firstColor
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = .zero
        
        addChild(world)
        world.setRadius(min(self.size.width,self.size.height) / 4)
        world.position = CGPoint(x: self.size.width/2, y:self.size.height/2)
        world.setAtmosphere(10 * world.radius)
        
        let gravityField = SKFieldNode.radialGravityField()
        gravityField.position = world.position
        gravityField.strength = 15
        gravityField.falloff = 0
        gravityField.categoryBitMask = CategoryMask.gravityField.rawValue
        gravityField.region = SKRegion(radius: Float(world.atmosphere))
        addChild(gravityField)
        
        addChild(player)
        player.setRadius(min(self.size.width,self.size.height) / 32)
        player.position = CGPoint(x: self.size.width/2 + world.frame.size.width/3, y:self.size.height/2 + world.frame.size.height)
        
        //category masks
        player.physicsBody?.categoryBitMask = CategoryMask.player.rawValue
        world.physicsBody?.categoryBitMask = CategoryMask.world.rawValue
        
        //collision masks
        player.physicsBody?.collisionBitMask = CategoryMask.world.rawValue | CategoryMask.enemy.rawValue  | CategoryMask.item.rawValue
        world.physicsBody?.collisionBitMask = CategoryMask.player.rawValue | CategoryMask.enemy.rawValue | CategoryMask.item.rawValue
        
        //contact masks
        player.physicsBody?.contactTestBitMask = CategoryMask.world.rawValue | CategoryMask.enemy.rawValue
        world.physicsBody?.contactTestBitMask = CategoryMask.player.rawValue | CategoryMask.enemy.rawValue
        
        
        scorelabel.position.x = self.frame.width/2
        scorelabel.position.y = self.frame.height - scorelabel.frame.size.height - 60
        scorelabel.fontName = "SanFranciscoDisplay-Heavy"
        scorelabel.color = UIColor.gameTheme.fourthColor
        scorelabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        addChild(scorelabel)
    }
    
    func addItem(pos: CGPoint){
        var item = Item()
        item.position = pos
        item.physicsBody?.categoryBitMask = CategoryMask.item.rawValue
        item.physicsBody?.collisionBitMask = CategoryMask.player.rawValue | CategoryMask.world.rawValue
        item.physicsBody?.contactTestBitMask = CategoryMask.player.rawValue | CategoryMask.world.rawValue
        addChild(item)
        item.run(SKAction.sequence([
            SKAction.wait(forDuration: 2),
            SKAction.removeFromParent()
        ]))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if activeTouches.count == 0{
                joystick = Joystick(width: 50)
                activeTouches[touch] = "joystick"
                joystick.position = CGPoint(x:touch.location(in: self).x, y:touch.location(in: self).y+50)
                addChild(joystick)
                hasJoystick = true
            } else {
                activeTouches[touch] = "other"
                jump()
            }
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if activeTouches[touch] == "joystick"{
                joystick.setKnobPosition(CGPoint(x:touch.location(in: self).x, y:touch.location(in: self).y+50))
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            guard let name = activeTouches[touch] else { fatalError("Touch just ended but not found into activeTouches")}
            if activeTouches[touch] == "joystick"{
                joystick.removeFromParent()
                hasJoystick = false
            }
            activeTouches[touch] = nil
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if hasJoystick{
            if joystick.getState() == .right {
                var angle = getAngle(obj1: player, obj2: world)
                angle -= 1
                player.zRotation = angle
            } else if joystick.getState() == .left {
                var angle = getAngle(obj1: player, obj2: world)
                angle += 1
                player.zRotation = angle
            }
        }
        
        if currentTime > renderTime {
            let prob = Int.random(in: 0...100)
            if prob > 50 {
                let radius = 2 * world.radius
                let angle = Float.random(in: 0..<(2 * .pi))
                let px = world.position.x + radius * CGFloat(cos(angle))
                let py = world.position.y + radius * CGFloat(sin(angle))
                addItem(pos: CGPoint(x:px, y:py))
            }
            renderTime = currentTime + spawnItem
        }
    }
    
    func jump(){
        if player.status == .onGround{
            // Calculate vector components x and y
            let pos = player.position
            let pos2 = world.position
            var dx = pos.x - pos2.x
            var dy = pos.y - pos2.y
            
            // Normalize the components
            let magnitude = sqrt(dx*dx+dy*dy)
            dx /= magnitude
            dy /= magnitude
            
            // Create a vector in the direction of the bird
            let force:CGFloat = 600
            let vector = CGVector(dx:force * dx, dy: force * dy)
            player.physicsBody?.applyImpulse( vector )
            player.status = .jumping
        }
        
    }
    
    func getAngle( obj1:SKNode, obj2:SKNode) -> CGFloat{
        let dx = obj1.position.x - obj2.position.x
        let dy = obj1.position.y - obj2.position.y
        return atan2(dy, dx)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.node?.name == "player" && contact.bodyB.node?.name == "world") ||
            (contact.bodyA.node?.name == "world" && contact.bodyB.node?.name == "player"){
            player.status = .onGround
        } else if (contact.bodyA.node?.name == "player" && contact.bodyB.node?.name == "item") ||
            (contact.bodyA.node?.name == "player" && contact.bodyB.node?.name == "item"){
            
            let item = ((contact.bodyA.node?.name == "player") ? contact.bodyB.node : contact.bodyA.node) as! Item
            
            item.removeFromParent()
            item.removeAllActions()
            score += 1
            scorelabel.text = "\(score)"
        }
    }
}

enum CategoryMask: UInt32 {
    case player = 0b0001
    case world = 0b0010
    case enemy = 0b0011
    case item = 0b0100
    case gravityField = 0b0101
}
