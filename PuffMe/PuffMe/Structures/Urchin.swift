//
//  Urchin.swift
//  PuffMe
//
//  Created by Thiago Parisotto on 26/09/23.
//

import Foundation
import SpriteKit

class Urchin : Animal {
    
    init(lifeTime: Int, position: CGPoint) {
        let sprite = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
        sprite.position = position
        sprite.name = "urchin"
        
        super.init(sprite: sprite, lifeTime: lifeTime)
        
    }
    
    
    
    
}
