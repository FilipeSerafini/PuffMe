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
    var speed: CGFloat = 40
    //var textures: [SKTexture] = []
    init(lifeTime: Int, position: CGPoint, size: CGSize) {
        let sprite = SKSpriteNode(color: .yellow, size: CGSize(width: 50, height: 50))
        sprite.position = position
        sprite.name = "puff"
        super.init(sprite: sprite, lifeTime: lifeTime)
        for _ in 1..<lifeTime {
            sprite.scale(to: CGSize(width: sprite.size.width * changeRate, height: sprite.size.height * changeRate))
        }
        let grow = SKAction.run(increaseSize)
        let wait = SKAction.wait(forDuration: 1)
        let move = puffMove(size: size)
        sprite.run(SKAction.repeatForever(SKAction.sequence([grow, wait])))
        sprite.run(SKAction.repeatForever(move), withKey: "move")
    }
    
    func puffMove(size: CGSize) -> SKAction {
        let position = generateRandomPointWithin(size: size)
        let distanceX = sprite.position.x - position.x
        let distanceY = sprite.position.y - position.y
        let distanceTotal = sqrt(distanceX*distanceX + distanceY*distanceY)
        let duration = distanceTotal/speed
        
        return SKAction.move(to: position, duration: duration)
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
