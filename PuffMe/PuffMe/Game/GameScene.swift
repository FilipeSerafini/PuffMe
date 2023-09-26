//
//  GameScene.swift
//  PuffMe
//
//  Created by Filipe Serafini on 25/09/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var puffs: [Puff] = []
    var urchin: Urchin?
    var star: Starfish?
    var player: Player = Player()
    
    var currLifetime: Int = 2
    var spawnRate: CGFloat = 1
    
    
    
    override func didMove(to view: SKView) {
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(generatePuff), SKAction.wait(forDuration: spawnRate)])))
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        //check puffs lifetime
        for puff in puffs {
            if puff.lifeTime > 5 {
                puff.sprite.removeAllActions()
                explodePuff(puff: puff)
            }
            if puff.lifeTime < 1 {
                savePuff(puff: puff)
            }
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            //touch puff
            if let node = self.atPoint(location) as? SKSpriteNode, node.name == "puff" {
                guard let puff = puffs.first(where: {$0.sprite.hashValue == node.hashValue}) else {return}
                
                puffTouch(puff: puff)
            }
            //touch urchin
            //touch star
        }
    }
    func urchinTouch() {
        
    }
    func starTouch() {
        
    }
    func puffTouch(puff: Puff) {
        puff.decreaseSize()
        if puff.lifeTime < 1 {
            savePuff(puff: puff)
        }
    }
    func generatePuff() {
        //create new puff
        let puff = Puff(direction: generateRandomPointWithin(size: size), lifeTime: randomInRange(min: 1, max: UInt32(currLifetime)), position: generateRandomPointWithin(size: size))
        //add puff to screen and array
        addChild(puff.sprite)
        puffs.append(puff)
        
    }
    func generateStar() {
        
    }
    func generateUrchin() {
        
    }
    func savePuff(puff: Puff) {
        removeAnimal(animal: puff)
        player.increaseScore()
    }
    func removeAnimal(animal: Animal) {
        if animal is Puff {
            puffs.removeAll { puff in
                puff.id == animal.id
            }
        }
        animal.sprite.removeFromParent()
    }
    func explodePuff(puff: Puff) {
        removeAnimal(animal: puff)
        player.loseHP()
    }
    func increaseDifficulty() {
        
    }
    func gameOver() {
        
    }
}

