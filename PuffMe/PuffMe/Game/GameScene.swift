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
    var lifes: [SKSpriteNode] = []
    
    var currLifetime: Int = 2
    var spawnRate: CGFloat = 1
    
    var scoreLabel: SKLabelNode?
    
    
    
    
    override func didMove(to view: SKView) {
        generateScoreLabel()
        createLifes()
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(generatePuff), SKAction.wait(forDuration: spawnRate)])))
    }
    
    override func update(_ currentTime: TimeInterval) {
        //checks for playes life
        checkLifes()
        //updates score
        self.scoreLabel?.text = "Score: \(player.score)"
        
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
    func generateScoreLabel() {
        self.scoreLabel = SKLabelNode(text: "Score: 0")
        self.scoreLabel?.position = CGPoint(x: size.width/2, y: size.height - 20)
        self.scoreLabel?.zPosition = 2
        self.scoreLabel?.fontSize = 20
        self.scoreLabel?.fontColor = .white
        self.scoreLabel?.fontName = "Helvetica-Bold"
        
        if let scoreLabel = self.scoreLabel {
            addChild(scoreLabel)
        }
    }
    func createLifes() {
        lifes = []
        for i in 0..<player.hp {
            let life = SKSpriteNode(color: .red, size: CGSize(width: 20, height: 20))
            life.position = CGPoint(x: 50 + (CGFloat(i) * 40), y: self.size.height - 50)
            lifes.append(life)
            addChild(life)
        }
    }
    func checkLifes() {
        if player.hp < 1 {
            player.hp = 3
            gameOver()
        }
        if player.hp != lifes.count {
            for life in lifes {
                life.removeFromParent()
            }
            createLifes()
        }
    }
}

