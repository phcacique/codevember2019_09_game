//
//  CGVector+CGPoint.swift
//  Game
//
//  Created by Pedro Cacique on 09/11/19.
//  Copyright © 2019 Pedro Cacique. All rights reserved.
//

import Foundation
import SpriteKit

extension CGPoint
{
    func distanceTo(point: CGPoint) -> CGFloat
    {
        return hypot(self.x - point.x, self.y - point.y)
    }
}

extension CGVector{
    mutating func rotate(_ angle:CGFloat){
        dx = dx * cos(angle) - dy * sin(angle)
        dy = dx * sin(angle) + dy * cos(angle)
    }
}
