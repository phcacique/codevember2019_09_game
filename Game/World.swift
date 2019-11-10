//
//  World.swift
//  Game
//
//  Created by Pedro Cacique on 09/11/19.
//  Copyright © 2019 Pedro Cacique. All rights reserved.
//

import Foundation
import SpriteKit

public class World: SKShapeNode {
    
    var mass: CGFloat
    var radius: CGFloat
    var gravity: CGFloat
    var atmosphere: CGFloat
    
    init( radius: CGFloat = 100, mass:CGFloat = 100, lineWidth: CGFloat = 0, color: UIColor =  UIColor.gameTheme.secondColor, gravity: CGFloat = 10, atmosphere: CGFloat = 300 ) {
        self.mass = mass
        self.radius = radius
        self.gravity = gravity
        self.atmosphere = atmosphere
        super.init()
        self.name = "world"
        self.setRadius(radius)
        self.lineWidth = lineWidth
        self.fillColor = color
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.radius)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.mass = mass

        setAtmosphere(atmosphere)
    }
    
    func setAtmosphere(_ a: CGFloat ){
        self.atmosphere = a
        
    }
    
    func setRadius(_ r: CGFloat){
        self.radius = r
        self.path = CGPath(ellipseIn: CGRect(x:self.position.x - radius, y:self.position.y - radius, width: 2 * radius, height: 2 * radius), transform: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
