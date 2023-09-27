//
//  Urchin.swift
//  PuffMe
//
//  Created by Thiago Parisotto on 26/09/23.
//

import Foundation
import SpriteKit

class Urchin : Animal {
    
    init() {
        let sprite = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
        sprite.position = CGPoint(x: -sprite.size.width / 2, y: sprite.size.height / 2)
        sprite.name = "urchin"
        
        super.init(sprite: sprite)
        
    }
    
    
    
    
}
