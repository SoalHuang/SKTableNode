//
//  SKExtensions.swift
//  SKTableNode
//
//  Created by soal on 24/05/2018.
//  Copyright © 2018 SoalHuang. All rights reserved.
//

import UIKit
import SpriteKit

internal extension CGRect {
    
    @discardableResult
    mutating func _internal_reset(origin: CGPoint) -> CGRect {
        self.origin = origin
        return self
    }
    
    @discardableResult
    mutating func _internal_reset(size: CGSize) -> CGRect {
        self.size = size
        return self
    }
}

internal extension SKView {
    func _internal_convert(_ point: CGPoint, from node: SKNode) -> CGPoint {
        return CGPoint(x: (node.position.x + point.x) + bounds.width * layer.anchorPoint.x,
                       y: -(node.position.y + point.y) + bounds.height * layer.anchorPoint.y)
    }
}

internal extension UIScrollView {
    var _internal_visiableRect: CGRect {
        return CGRect(origin: contentOffset, size: bounds.size)
    }
}

internal extension Array {
    func _internal_optional(at index: Int) -> Element? {
        guard self.count > 0, index > 0, index < self.count - 1 else { return nil }
        return self[index]
    }
}
