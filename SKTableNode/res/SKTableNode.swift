//
//  SKTableNode.swift
//  SKTableNode
//
//  Created by SoalHunag on 2018/5/23.
//  Copyright © 2018年 SoalHuang. All rights reserved.
//

import SpriteKit

/* @ Also see Class UITableView
 */
open class SKTableNode: SKScrollNode {
    
    open weak var tableDataSource: SKTableNodeDataSource? {
        didSet {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(performReloadData), object: nil)
            self.perform(#selector(performReloadData), with: nil, afterDelay: 0.02)
        }
    }
    
    open weak var tableDelegate: SKTableNodeDelegate? {
        didSet {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(performReloadData), object: nil)
            self.perform(#selector(performReloadData), with: nil, afterDelay: 0.02)
        }
    }
    
    @objc func performReloadData() { reloadData() }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(size: CGSize, target: SKView) {
        super.init(size: size, target: target)
        isPagingEnabled = false
        isScrollEnabled = true
        isDirectionalLockEnabled = true
        alwaysBounceVertical = true
        alwaysBounceHorizontal = false
        showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    open override var showsHorizontalScrollIndicator: Bool {
        get { return scrollView.showsHorizontalScrollIndicator }
        set { /* do nothing */ }
    }
    
    open var rowHeight: CGFloat = 44
    
    private var allCellRangeMap: [SKTableCellBounds] = []
    
    open func reloadData() {
        allCellRangeMap.removeAll()
        contentNode.removeAllChildren()
        let rows = tableDataSource?.numberOfRows(in: self) ?? 0
        guard rows > 0 else { return }
        var posY: CGFloat = 0
        for index in 0..<rows {
            let ch = tableDelegate?.tableNode?(self, heightForRowAt: index) ?? rowHeight
            allCellRangeMap.append(SKTableCellBounds(index: index, lower: posY, upper: posY + ch))
            posY += ch
        }
        contentSize = CGSize(width: size.width, height: posY)
        update(render: scrollView._internal_visiableRect)
    }
    
    private func update(render rect: CGRect) {
        let outside = allCellRangeMap.filter { $0.cell != nil && !$0.contains(rect: rect) }
        outside.forEach { recycle($0) }
        guard let dataSource = tableDataSource else { return }
        let inside = allCellRangeMap.filter { $0.cell == nil && $0.contains(rect: rect) }
        inside.forEach {
            let cell = dataSource.tableNode(self, cellForRowAt: $0.index)
            cell.index = $0.index
            cell.size = CGSize(width: size.width, height: $0.height)
            cell.position = CGPoint(x: 0, y: size.height / 2 - $0.middle)
            contentNode.addChild(cell)
            $0.cell = cell
        }
    }
    
    open func numberOfRows() -> Int {
        return tableDataSource?.numberOfRows(in: self) ?? 0
    }
    
    open func positionForRow(at index: Int) -> CGPoint? {
        guard let bd = allCellRangeMap._internal_optional(at: index) else { return nil }
        return CGPoint(x: 0, y: bd.middle)
    }
    
    open func indexForRow(at point: CGPoint) -> Int? {
        for index in 0..<allCellRangeMap.count {
            if allCellRangeMap[index].isInside(bound: point.y) {
                return index
            }
        }
        return nil
    }
    
    /// returns nil if cell is not visible
    open func index(for cell: SKTableNodeCell) -> Int? {
        return allCellRangeMap.filter { $0.cell == cell }.first?.index
    }
    
    open func indexsForRows(in rect: CGRect) -> [Int] {
        return allCellRangeMap.filter { $0.cell != nil && $0.contains(rect: rect) }.compactMap { $0.index }
    }
    
    /// returns nil if cell is not visible or index path is out of range
    open func cellForRow(at index: Int) -> SKTableNodeCell? {
        return allCellRangeMap._internal_optional(at: index)?.cell
    }
    
    open var indexsForVisibleRows: [Int] {
        return allCellRangeMap.filter { $0.cell != nil }.compactMap { $0.index }
    }
    
    open var visibleCells: [SKTableNodeCell] {
        var vscs: [SKTableNodeCell] = []
        _p_visible_cells_.forEach { vscs.append(contentsOf: $0.value) }
        return vscs.sorted(by: { $0.index < $1.index })
    }
    
    open func scrollToRow(at index: Int, at scrollPosition: UITableViewScrollPosition, animated: Bool) {
        guard let cb = allCellRangeMap._internal_optional(at: index) else { return }
        var offsetY: CGFloat = cb.middle
        switch scrollPosition {
        case .top:      offsetY = cb.lower
        case .bottom:   offsetY = cb.upper
        default: break
        }
        scrollView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: animated)
    }
    
    open var indexsForSelectedRows: [Int] {
        var ixs: [Int] = []
        _p_visible_cells_.forEach { $0.value.forEach{ if $0.isSelected { ixs.append($0.index) } } }
        return ixs.sorted()
    }
    
    open func selectRow(at index: Int, animated: Bool, scrollPosition: UITableViewScrollPosition) {
        
    }
    
    open func deselectRow(at index: Int, animated: Bool) {
        
    }
    
    private var _p_visible_cells_: [String:[SKTableNodeCell]] = [:]
    private var _p_recycle_cells_: [String:[SKTableNodeCell]] = [:]
    
    private var _p_rg_cell_types_: [String:Swift.AnyClass?] = [:]
    
    open func register(_ cellClass: Swift.AnyClass?, forCellWithReuseIdentifier identifier: String) {
        assert(cellClass is SKTableNodeCell.Type, "SKTableNode cell class must inherit from SKTableNodeCell")
        _p_rg_cell_types_[identifier] = cellClass
        _p_visible_cells_[identifier] = []
        _p_recycle_cells_[identifier] = []
    }
    
    open func dequeueReusableCell(withReuseIdentifier identifier: String) -> SKTableNodeCell? {
        guard let cellClass = _p_rg_cell_types_[identifier] as? SKTableNodeCell.Type else { return nil }
        if let wrapedCell = _p_recycle_cells_[identifier]?.first {
            wrapedCell.prepareForReuse()
            _p_recycle_cells_[identifier]?.removeFirst(1)
            _p_visible_cells_[identifier]?.append(wrapedCell)
            return wrapedCell
        }
        let cell = cellClass.init(reuseIdentifier: identifier)
        _p_visible_cells_[identifier]?.append(cell)
        return cell
    }
    
    private func recycle(_ bd: SKTableCellBounds) {
        let remove = { bd.cell?.removeFromParent(); bd.cell = nil }
        guard let cell = bd.cell, let id = cell.reuseIdentifier else {
            remove()
            return
        }
        if let index = _p_visible_cells_[id]?.index(of: cell) {
            _p_visible_cells_[id]?.remove(at: index)
        }
        _p_recycle_cells_[id]?.append(cell)
        remove()
    }
    
    override func _proxyScrollViewDidScroll(_ scrollView: UIScrollView) {
        super._proxyScrollViewDidScroll(scrollView)
        update(render: scrollView._internal_visiableRect)
    }
}

@objc public protocol SKTableNodeDataSource {
    
    func numberOfRows(in tableNode: SKTableNode) -> Int

    func tableNode(_ tableNode: SKTableNode, cellForRowAt index: Int) -> SKTableNodeCell
}

@objc public protocol SKTableNodeDelegate: SKScrollNodeDelegate {
    
    // Variable height support
    @objc optional func tableNode(_ tableNode: SKTableNode, heightForRowAt index: Int) -> CGFloat
    
    @objc optional func tableNode(_ tableNode: SKTableNode, shouldHighlightRowAt index: Int) -> Bool
    
    @objc optional func tableNode(_ tableNode: SKTableNode, didHighlightRowAt index: Int)
    
    @objc optional func tableNode(_ tableNode: SKTableNode, didSelectRowAt index: Int)
    
    @objc optional func tableNode(_ tableNode: SKTableNode, didDeselectRowAt index: Int)
}

fileprivate class SKTableCellBounds {
    
    var index: Int = 0
    var lower: CGFloat = 0.0
    var upper: CGFloat = 0.0
    
    weak var cell: SKTableNodeCell?
    
    var middle: CGFloat {
        return (lower + upper) / 2
    }
    
    var height: CGFloat {
        return upper - lower
    }
    
    convenience init(index: Int, lower: CGFloat = 0.0, upper: CGFloat = 0.0) {
        self.init()
        self.index = index
        self.lower = lower
        self.upper = upper
    }
    
    func isInside(bound: CGFloat) -> Bool {
        return bound > lower && bound < upper
    }
    
    func contains(rect: CGRect) -> Bool {
        let allU = lower > rect.maxY && upper > rect.maxY
        let allL = lower < rect.minY && upper < rect.minY
        return !(allU || allL)
    }
}
