//
//  LogPiece.swift
//  TestTimberMan
//
//  Created by Bruno Thuma on 19/03/24.
//

import SpriteKit

class LogPiece: SKSpriteNode {
    var rightBranch: SKSpriteNode!
    var leftBranch: SKSpriteNode!
    
    var side: Side = .none {
        didSet {
            switch side {
            case .left:
                leftBranch.isHidden = false
            case .right:
                rightBranch.isHidden = false
            case .none:
                rightBranch.isHidden = true
                leftBranch.isHidden = true
            }
        }
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func connectBranches() {
        rightBranch = (childNode(withName: "rightBranch") as! SKSpriteNode)
        leftBranch = (childNode(withName: "leftBranch") as! SKSpriteNode)
        
        side = .none
    }
}
