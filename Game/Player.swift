//
//  Player.swift
//  Game
//
//  Created by Pedro Cacique on 09/11/19.
//  Copyright © 2019 Pedro Cacique. All rights reserved.
//

import Foundation
import SpriteKit

public class Player: SKShapeNode{
    
    var mass: CGFloat
    var radius: CGFloat
    var status: PlayerStatus
    
    init( radius: CGFloat = 10, mass:CGFloat = 1, lineWidth: CGFloat = 0, color: UIColor = UIColor.gameTheme.thirdColor, status: PlayerStatus = .falling ) {
        self.mass = mass
        self.radius = radius
        self.status = status
        super.init()
        self.name = "player"
        self.setRadius(radius)
        self.lineWidth = lineWidth
        self.fillColor = color
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: self.frame.height))
        self.physicsBody?.isDynamic = true
        self.physicsBody?.mass = mass
        self.physicsBody?.fieldBitMask = CategoryMask.gravityField.rawValue
    }
    
    func setRadius(_ r: CGFloat){
        self.radius = r
        self.path = CGPath(rect: CGRect(x:self.position.x - radius, y:self.position.y - radius, width: 2 * radius, height: 2 * radius), transform: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum PlayerStatus {
    case onGround, jumping, falling, running, idle
}
