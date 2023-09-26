//
//  Puff.swift
//  PuffMe
//
//  Created by Thiago Parisotto on 26/09/23.
//

import Foundation
import SpriteKit

class Puff : Animal {
    var changeRate: CGFloat = 1.5
    //var textures: [SKTexture] = []
    init(direction: CGPoint, lifeTime: Int, position: CGPoint) {
        let sprite = SKSpriteNode(color: .yellow, size: CGSize(width: 50, height: 50))
        sprite.position = position
        sprite.name = "puff"
        super.init(sprite: sprite, direction: direction, lifeTime: lifeTime)
        for _ in 1..<lifeTime {
            sprite.scale(to: CGSize(width: sprite.size.width * changeRate, height: sprite.size.height * changeRate))
        }
        let grow = SKAction.run(increaseSize)
        let wait = SKAction.wait(forDuration: 1)
        sprite.run(SKAction.repeatForever(SKAction.sequence([grow, wait])))
        
    }
    
    func increaseSize() {
        if(lifeTime < 6){
            let scaleAction = SKAction.scale(by: changeRate, duration: 1)
            let incLifeTime = SKAction.run(increaseLifeTime)
            sprite.run(SKAction.sequence([scaleAction, incLifeTime]))
        }
        //sprite.scale(to: CGSize(width: sprite.size.width * changeRate, height: sprite.size.height * changeRate))
    }
    func increaseLifeTime() {
        lifeTime += 1
        //changeRate += 0.5
    }
    func decreaseSize() {
        sprite.scale(to: CGSize(width: sprite.size.width / changeRate, height: sprite.size.height / changeRate))
        lifeTime -= 1
    }
}
