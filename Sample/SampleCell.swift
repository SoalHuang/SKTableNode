//
//  SampleCell.swift
//  Sample
//
//  Created by soal on 26/05/2018.
//  Copyright © 2018 soso. All rights reserved.
//

import SpriteKit

class SampleCell: SKTableNodeTitleCell {
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        labelNode.color = UIColor.red
    }
}
