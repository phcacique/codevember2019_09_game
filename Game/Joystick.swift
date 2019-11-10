//
//  Joystick.swift
//  Game
//
//  Created by Pedro Cacique on 09/11/19.
//  Copyright © 2019 Pedro Cacique. All rights reserved.
//

import Foundation
import SpriteKit

public class Joystick : SKNode {
    
    var knob:SKShapeNode
    var color:UIColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
    var w:CGFloat
    
    init(width:CGFloat) {
        w = width
        let bg:SKShapeNode = SKShapeNode(rect: CGRect(x: -width/2, y: 0, width: width, height: width/4), cornerRadius: width/8)
        bg.fillColor = UIColor.gameTheme.secondColor.withAlphaComponent(0.2)
               bg.lineWidth = 0
        
        knob = SKShapeNode(circleOfRadius: width/6)
        knob.position = CGPoint(x: 0, y:width/8)
        knob.fillColor = color.withAlphaComponent(0.8)
        knob.lineWidth = 0
        super.init()

        addChild(bg)
        
        addChild(knob)
    }
    
    func setKnobPosition(_ pos:CGPoint){
        let diffX:CGFloat = pos.x - position.x
        knob.position.x += diffX
        
        if knob.position.x > w/2 {
            knob.position.x = w/2
        } else if knob.position.x < -w/2 {
            knob.position.x = -w/2
        }
    }
    
    func getState() -> JoystickState{
        if knob.position.x >  w/4{
            return .right
        } else if knob.position.x <  -w/4 {
            return .left
        } else {
            return .stoped
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

enum JoystickState {
    case stoped, left, right
}
