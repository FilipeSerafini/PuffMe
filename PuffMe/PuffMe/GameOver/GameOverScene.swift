//
//  GameOverScene.swift
//  PuffMe
//
//  Created by Filipe Serafini on 25/09/23.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    var score: Int
    var highscore: Int
    init(size: CGSize, score: Int, highscore: Int) {
        self.highscore = highscore
        self.score = score
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func didMove(to view: SKView) {
        // Create a Title Label
        let titleLabel = SKSpriteNode(imageNamed: "gameOver")
        titleLabel.size = CGSize(width: 300, height: 150)
        titleLabel.position = CGPoint(x: size.width / 2, y: size.height - 100)
        addChild(titleLabel)
        
        //show score
        let scoreLabel = SKLabelNode(text: "Your score: \(score)!")
        scoreLabel.fontSize = 20
        scoreLabel.fontName = "Helvetica-Bold"
        scoreLabel.fontColor = .red
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - 200)
        addChild(scoreLabel)
        
        //show highscore
        let highscoreLabel = SKLabelNode(text: "Highscore: \(highscore)!")
        highscoreLabel.fontSize = 20
        highscoreLabel.fontName = "Helvetica-Bold"
        highscoreLabel.fontColor = .red
        highscoreLabel.position = CGPoint(x: size.width / 2, y: size.height - 230)
        addChild(highscoreLabel)
        
        let restartButton = SKSpriteNode(texture: SKTexture(imageNamed: "restartButton"))
        restartButton.scale(to: CGSize(width: 300, height: 100))
        restartButton.position = CGPoint(x: size.width / 2, y: size.height - 260)
        restartButton.size = CGSize(width: 200, height: 50)
        restartButton.name = "restartButton" // Set a name for identifying the node later
        addChild(restartButton)
        
        let backToMenuButton = SKSpriteNode(texture: SKTexture(imageNamed: "backToMenuButton"))
        backToMenuButton.scale(to: CGSize(width: 300, height: 100))
        backToMenuButton.position = CGPoint(x: size.width / 2, y: size.height - 320)
        backToMenuButton.size = CGSize(width: 200, height: 50)
        backToMenuButton.name = "backToMenu" // Set a name for identifying the node later
        addChild(backToMenuButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            //restar game button
            if let node = self.atPoint(location) as? SKSpriteNode, node.name == "restartButton" {
                let scene = GameScene(size: CGSize(width: size.width, height: size.height))
                scene.scaleMode = .aspectFill
                
                let transition = SKTransition.fade(withDuration: 1.0)
                self.view?.presentScene(scene, transition: transition)
            }
            //back to menu button
            if let node = self.atPoint(location) as? SKSpriteNode, node.name == "backToMenu" {
                let scene = MenuScene(size: CGSize(width: size.width, height: size.height))
                scene.scaleMode = .aspectFill
                
                let transition = SKTransition.fade(withDuration: 1.0)
                self.view?.presentScene(scene, transition: transition)
            }
        }
    }
    
}
