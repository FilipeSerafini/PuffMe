//
//  TutorialScene.swift
//  PuffMe
//
//  Created by Thiago Parisotto on 28/09/23.
//

import Foundation
import SpriteKit

class TutorialScene: GameScene {
    var title: SKLabelNode?
    var tutDescription: SKLabelNode?
    var imageSprite: SKSpriteNode?
    var continueButton: SKSpriteNode?
    var currPage = 1
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(texture: SKTexture(imageNamed: "background"))
        background.scale(to: CGSize(width: size.width, height: size.height))
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -2
        addChild(background)
        
        let newTitle = SKLabelNode(text: "Puff")
        
        newTitle.fontSize = 30
        newTitle.position = CGPoint(x: size.width/2, y: size.height - 50)
        newTitle.color = .white
        newTitle.fontName = "Helvetica-Bold"
        newTitle.scene?.backgroundColor = .black
        title = newTitle
        
        let tutDescriptionText = "These are Puffs, pufferfishes. They are afraid of ocean pollution and are inflating until they explode. Save the puffs by clicking on them to deflate them and prevent them from exploding."
        let descriptionFontSize: CGFloat = 24
        let descriptionWidth: CGFloat = size.width - 100  // Adjust the value as needed
        let descriptionHeight: CGFloat = 250  // Adjust the value as needed
        
        let newtutDescription = SKLabelNode(fontNamed: "Helvetica")
        newtutDescription.fontSize = descriptionFontSize
        newtutDescription.position = CGPoint(x: size.width / 2, y: size.height - 180)
        newtutDescription.color = .white
        newtutDescription.horizontalAlignmentMode = .center
        newtutDescription.numberOfLines = 0  // Allow multiple lines
        newtutDescription.preferredMaxLayoutWidth = descriptionWidth
        newtutDescription.text = tutDescriptionText
        
        // Calculate the label's height based on the text content
        let descriptionLabelHeight = newtutDescription.calculateAccumulatedFrame().height
        
        // Check if the label exceeds the available height
        if descriptionLabelHeight > descriptionHeight {
            newtutDescription.position.y -= (descriptionLabelHeight - descriptionHeight) / 2
        }
        tutDescription = newtutDescription
        
        let imageLabel = SKSpriteNode(imageNamed: "puff3")
        imageLabel.scale(to: CGSize(width: 100, height: 100))
        imageLabel.position = CGPoint(x: size.width/2, y: size.height - 250)
        imageSprite = imageLabel
        
        
        let newContinueButton = SKSpriteNode(imageNamed: "pauseContinue")
        newContinueButton.position = CGPoint(x: size.width/2, y: size.height - 330)
        newContinueButton.size = CGSize(width: 260, height: 100)
        newContinueButton.name = "continue"
        continueButton = newContinueButton
        
        addChild(title!)
        addChild(tutDescription!)
        addChild(continueButton!)
        addChild(imageSprite!)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if let node = self.atPoint(location) as? SKSpriteNode, node.name == "continue" {
                vibrate(intensity: .medium)
                nextPage()
            }
        }
    }
    func nextPage() {
        switch currPage{
        case 1:
            title?.text = "Urchins"
            tutDescription?.text = "These are urchins, don't confuse them with the puffs, they cause damage when you touch them."
            imageSprite?.texture = SKTexture(imageNamed: "urchin")
            
            break
        case 2:
            title?.text = "Star Fishes"
            tutDescription?.text = "These are starfish, their lives are in the top-left corner. When they appear on the screen, touch them to ensure one more life."
            imageSprite?.texture = SKTexture(imageNamed: "star")
            break
        case 3:
            let scene = GameScene(size: CGSize(width: size.width, height: size.height))
            scene.scaleMode = .aspectFill
            
            let transition = SKTransition.fade(withDuration: 1.0)
            self.view?.presentScene(scene, transition: transition)
            break
        default:
            break
        }
        
        
        
        currPage += 1
    }
}
