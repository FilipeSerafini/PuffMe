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
    var backToMenu: SKLabelNode?
    var playAgain: SKLabelNode?
    
    init(size: CGSize, score: Int, highscore: Int) {
        self.highscore = highscore
        self.score = score
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.scale(to: CGSize(width: size.width, height: size.height))
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -2
        addChild(background)
        
        // Create a Title Label
        let titleLabel = SKSpriteNode(imageNamed: "gameOver")
        titleLabel.size = CGSize(width: 300, height: 150)
        titleLabel.position = CGPoint(x: size.width / 2, y: size.height - 100)
        addChild(titleLabel)
        
        //show score
        let scoreLabel = SKLabelNode(text: "Your score: \(score).")
        scoreLabel.fontSize = 20
        scoreLabel.fontColor = .white
        scoreLabel.fontName = "SFProRounded-Regular"
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - 200)
        addChild(scoreLabel)
        
        //show highscore
        let highscoreLabel = SKLabelNode(text: "Highscore: \(highscore).")
        highscoreLabel.fontSize = 20
        highscoreLabel.fontColor = .white
        highscoreLabel.fontName = "SFProRounded-Regular"
        highscoreLabel.position = CGPoint(x: size.width / 2, y: size.height - 230)
        addChild(highscoreLabel)
        
        let newPlayAgain = SKLabelNode(text: "Play Again")
        newPlayAgain.name = "playAgain"
        newPlayAgain.fontSize = 30
        newPlayAgain.fontColor = .white
        newPlayAgain.fontName = "SFProRounded-Bold"
        newPlayAgain.position = CGPoint(x: size.width / 2, y: size.height - 280)
        playAgain = newPlayAgain
        if let playAgain {
            addChild(playAgain)
        }
        
        
        let backToMenuButton = SKLabelNode(text: "Back to Menu")
        backToMenuButton.name = "backToMenu"
        backToMenuButton.fontSize = 30
        backToMenuButton.fontColor = .white
        backToMenuButton.fontName = "SFProRounded-Bold"
        backToMenuButton.position = CGPoint(x: size.width / 2, y: size.height - 330)
        backToMenu = backToMenuButton
        if let backToMenu {
            addChild(backToMenu)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            //restar game button
            if let node = self.atPoint(location) as? SKLabelNode, node.name == "playAgain" {
                vibrate(intensity: .medium)
                let scene = GameScene(size: CGSize(width: size.width, height: size.height))
                scene.scaleMode = .aspectFill
                
                let transition = SKTransition.fade(withDuration: 1.0)
                self.view?.presentScene(scene, transition: transition)
            }
            //back to menu button
            if let node = self.atPoint(location) as? SKLabelNode, node.name == "backToMenu" {
                vibrate(intensity: .medium)
                let scene = MenuScene(size: CGSize(width: size.width, height: size.height))
                scene.scaleMode = .aspectFill
                
                let transition = SKTransition.fade(withDuration: 1.0)
                self.view?.presentScene(scene, transition: transition)
            }
        }
    }
    
}
