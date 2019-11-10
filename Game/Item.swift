//
//  Item.swift
//  Game
//
//  Created by Pedro Cacique on 09/11/19.
//  Copyright © 2019 Pedro Cacique. All rights reserved.
//

import Foundation
import SpriteKit

public class Item: SKShapeNode{
    
    var mass: CGFloat
    var radius: CGFloat
    
    init( radius: CGFloat = 5, mass:CGFloat = 1, lineWidth: CGFloat = 0, color: UIColor = UIColor.gameTheme.fourthColor, status: PlayerStatus = .falling ) {
        self.mass = mass
        self.radius = radius
        super.init()
        self.name = "item"
        self.setRadius(radius)
        self.lineWidth = lineWidth
        self.fillColor = color
        self.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.mass = mass
        self.physicsBody?.fieldBitMask = CategoryMask.gravityField.rawValue
    }
    
    func setRadius(_ r: CGFloat){
        self.radius = r
        self.path = CGPath(ellipseIn: CGRect(x:self.position.x - radius, y:self.position.y - radius, width: 2 * radius, height: 2 * radius), transform: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
