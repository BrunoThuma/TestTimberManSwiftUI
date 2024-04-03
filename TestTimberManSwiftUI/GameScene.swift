//
//  GameScene.swift
//  TestTimberMan
//
//  Created by Bruno Thuma on 17/03/24.
//

import SpriteKit
import GameplayKit
import GoogleMobileAds

enum Side: CaseIterable {
    case left, right, none
}

enum GameState {
    case ready, playing, gameOver
}

class GameScene: SKScene, GADFullScreenContentDelegate {
    var logBasePiece: LogPiece!
    var playerNode: PlayerNode!
        
    var gameOverLabel: SKLabelNode!
    var tryAgainLabel: SKLabelNode!
    
    var tree: [LogPiece] = []
    
    var state: GameState = .ready
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        // identificador de teste
        RewardedAd.shared.loadAd(withAdUnitId: "ca-app-pub-3940256099942544/5224354917")
        
        logBasePiece = (childNode(withName: "log") as! LogPiece)
        logBasePiece.connectBranches()
        
        logBasePiece.isHidden = true
        
        playerNode = (childNode(withName: "player") as! PlayerNode)
        
        gameOverLabel = (childNode(withName: "GameOverLabel") as! SKLabelNode)
        gameOverLabel.isHidden = true
        
        tryAgainLabel = (childNode(withName: "TryAgainLabel") as! SKLabelNode)
        tryAgainLabel.isHidden = true
        
        addTreeLog(side: .none)
        addRandomLogs(total: 10)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        
        let nodes = nodes(at: touch.location(in: self))
        
        for node in nodes {
            if node.name == "TryAgainLabel" {
                showRewardedAd()
                return
            }
        }
        
        if state == .gameOver {
            restartGame()
            return
        }
        
        if state == .ready { state = .playing }
        
        let location = touch.location(in: self)
        
        /* se encostou na direita */
        if location.x > size.width / 2 {
            playerNode.side = .right
        } else {
            playerNode.side = .left
        }
        
        
        if let firstLog = tree.first as LogPiece? {
            
            if playerNode.side == firstLog.side {
                gameOver()
                return
            }
            
            tree.removeFirst()
            
            firstLog.removeFromParent()
            
            addRandomLogs(total: 1)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveLogsDown()
    }
    
    private func showRewardedAd() {
        if let ad = RewardedAd.shared.rewardedAd {
            ad.fullScreenContentDelegate = self
            ad.present(fromRootViewController: self.view?.window?.rootViewController) {
                // Adiciona o seu bonus aqui
            }
        }
    }
    
    func adDidDismissFullScreenContent(_ ad: any GADFullScreenPresentingAd) {
        restartGame()
    }
    
    private func restartGame() {
        state = .ready
        gameOverLabel.isHidden = true
        tryAgainLabel.isHidden = true
        
        let skView = self.view as SKView?

        /* Load Game scene */
        guard let scene = GameScene(fileNamed: "GameScene") as GameScene? else {
            return
        }

        /* Ensure correct aspect mode */
        scene.scaleMode = .aspectFill

        /* Restart GameScene */
        skView?.presentScene(scene)
    }
    
    private func gameOver() {
        state = .gameOver
        
        let turnRedAction = SKAction.colorize(with: .red,
                                              colorBlendFactor: 0.8,
                                              duration: 0.3)
        
        playerNode.run(turnRedAction)
        
        gameOverLabel.isHidden = false
        tryAgainLabel.isHidden = false
    }
    
    private func moveLogsDown() {
        var n: CGFloat = 0
        
        for log in tree {
            /* continha maluca, facil de ser perder*/
            let y = (n * logBasePiece.size.height) + (logBasePiece.position.y + logBasePiece.size.height)
            log.position.y -= (log.position.y - y) * 0.45
            n += 1
        }
    }
    
    private func addTreeLog(side: Side) {
        let newLog = logBasePiece.copy() as! LogPiece
        newLog.connectBranches()
        
        let lastLog = tree.last
        
        let lastPosition = lastLog?.position ?? logBasePiece.position
        newLog.position.x = lastPosition.x
        newLog.position.y = lastPosition.y - newLog.size.height
        
        if lastLog == nil {
            newLog.position.y += newLog.size.height
        }
        
        newLog.side = side
        
        newLog.isHidden = false
        
        addChild(newLog)
        
        tree.append(newLog)
    }
    
    private func addRandomLogs(total: Int) {
        for _ in 1...total {
            let lastLog: LogPiece = tree.last ?? logBasePiece
            
            if lastLog.side != .none {
                addTreeLog(side: .none)
            } else {
                addTreeLog(side: Side.allCases.randomElement()!)
            }
        }
    }
}
