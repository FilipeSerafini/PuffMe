//
//  Animal.swift
//  PuffMe
//
//  Created by Thiago Parisotto on 26/09/23.
//

import Foundation
import SpriteKit

class Animal {
    var sprite: SKSpriteNode
    var direction: CGPoint
    var lifeTime: Int
    var id = UUID()
    
    init(sprite: SKSpriteNode, direction: CGPoint, lifeTime: Int) {
        self.sprite = sprite
        self.direction = direction
        self.lifeTime = lifeTime
    }
    
    func move() {
        
    }
}
