//
//  GameScene.swift
//  PuffMe
//
//  Created by Filipe Serafini on 25/09/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //charcters
    var puffs: [Puff] = []
    var urchin: Urchin?
    var star: Starfish?
    var player: Player = Player()
    var lifes: [SKSpriteNode] = []
    
    //puff variables
    var currLifetime: Int = 2
    var spawnRate: CGFloat = 1

    //star variables
    var starSpeed = 5.0
    var starSpawnTime = 10.0
    
    //game variables
    var scoreLabel: SKLabelNode?
    
    override func didMove(to view: SKView) {
        //generates the score
        generateScoreLabel()

        //generates the lifes
        createLifes()

        //generates puffs based on spawn rate
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(generatePuff), SKAction.wait(forDuration: spawnRate)])))
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        //generates star if player hp is not full
        if player.hp < 3 && star == nil {
            run(SKAction.repeatForever(SKAction.sequence([SKAction.run(generateStar), SKAction.wait(forDuration: starSpawnTime)])))
        }
        
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
            if let node = self.atPoint(location) as? SKSpriteNode, node.name == "starfish" {
                starTouch()
            }
        }
    }
    
    func urchinTouch() {
        
    }
    
    func starTouch() {
        player.hp += 1
        removeAnimal(animal: star!)
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
        //creates new star
        star = Starfish(lifeTime: 1)
        addChild(star!.sprite)
        
        //sequence of actions
        let appear = SKAction.scale(to: 0.3, duration: 0.5)
        let move = SKAction.moveTo(x: size.width + star!.sprite.size.width / 2, duration: starSpeed)
        let removeFromParent = SKAction.removeFromParent()
        let actions = [appear, move, removeFromParent]
        let rotateAction = SKAction.rotate(byAngle: .pi, duration: starSpeed)
        
        star!.sprite.run(SKAction.repeatForever(rotateAction))
        star!.sprite.run(SKAction.sequence(actions))
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

