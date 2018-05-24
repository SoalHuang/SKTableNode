//
//  SKTableCellNode.swift
//  SKTableNode
//
//  Created by soal on 24/05/2018.
//  Copyright © 2018 SoalHuang. All rights reserved.
//

import SpriteKit

open class SKTableNodeCell: SKSpriteNode {
    
    open private(set) var reuseIdentifier: String?
    
    open internal(set) var index: Int = 0
    
    open var isSelected: Bool = false
    
    open var isHighlighted: Bool = false
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required public init(reuseIdentifier: String?) {
        super.init(texture: nil, color: UIColor.white, size: .zero)
        self.reuseIdentifier = reuseIdentifier
        
    }
    
    open func prepareForReuse() {
        index = 0
        isSelected = false
        isHighlighted = false
    }
    
    private let contentNode_ = SKNode()
    public var contentNode: SKNode {
        if contentNode_.parent != self {
            contentNode_.removeFromParent()
        }
        if contentNode_.parent == nil {
            addChild(contentNode_)
        }
        return contentNode_
    }
}

open class SKTableNodeTitleCell: SKTableNodeCell {
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required public init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentNode.addChild(labelNode)
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        labelNode.text = nil
    }
    
    public lazy var labelNode: SKLabelNode = {
        let label = SKLabelNode()
        return label
    }()
}
