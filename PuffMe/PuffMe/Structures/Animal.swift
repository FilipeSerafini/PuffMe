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
    var id = UUID()
    
    init(sprite: SKSpriteNode) {
        self.sprite = sprite
    }
}
