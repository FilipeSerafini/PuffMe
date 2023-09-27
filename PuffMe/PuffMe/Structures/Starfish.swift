//
//  Starfish.swift
//  PuffMe
//
//  Created by Thiago Parisotto on 26/09/23.
//

import Foundation
import SpriteKit

class Starfish : Animal {
    init(lifeTime: Int) {
        let sprite = SKSpriteNode(imageNamed: "tempStar")
        //sprite.position = position
        sprite.name = "starfish"
        sprite.position = CGPoint(x: -sprite.size.width / 2, y: sprite.size.height / 2)
        super.init(sprite: sprite, lifeTime: lifeTime)
        
    }
}
