//
//  Starfish.swift
//  PuffMe
//
//  Created by Thiago Parisotto on 26/09/23.
//

import Foundation
import SpriteKit

class Starfish : Animal {
    var texture = SKTexture(imageNamed: "star")
    init() {
        let sprite = SKSpriteNode(texture: texture)
        sprite.scale(to: CGSize(width: 50, height: 50))
        sprite.name = "starfish"
        sprite.position = CGPoint(x: -sprite.size.width / 2, y: sprite.size.height / 2)
        super.init(sprite: sprite)
        
    }
}
