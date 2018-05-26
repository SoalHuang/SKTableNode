//
//  SKScrollNode.swift
//  SKTableNode
//
//  Created by SoalHunag on 2018/5/23.
//  Copyright © 2018年 SoalHuang. All rights reserved.
//

import SpriteKit

/* @ Also see Class UIScrollView
 */
@available(iOS 2.0, *)
open class SKScrollNode: SKNode {
    
    internal private(set) weak var target_: SKView?
    
    open weak var scrollDelegate: SKScrollNodeDelegate?
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(size: CGSize, target: SKView) {
        self.size = size
        target_ = target
        super.init()
        target.addSubview(scrollView)
        scrollView.center = target._internal_convert(.zero, from: self)
        scrollView.eventProxy = self
        scrollViewDelegateProxy.delegate = self
        
        cropNode.maskNode = backgroundNode
        cropNode.addChild(contentNode)
        addChild(cropNode)
        
    }
    
    private let scrollViewDelegateProxy = _Scroll_Delegate_Proxy_()
    
    private let cropNode = SKCropNode()
    
    open lazy var backgroundNode: SKSpriteNode = {
        let node = SKSpriteNode(color: .clear, size: self.size)
        node.zPosition = -2
        return node
    }()
    
    open lazy var contentNode: SKNode = {
        let node = SKSpriteNode(color: .clear, size: self.size)
        node.zPosition = -1
        return node
    }()
    
    open override func removeFromParent() {
        scrollView.removeFromSuperview()
        super.removeFromParent()
    }
    
    open override func move(toParent parent: SKNode) {
        super.move(toParent: parent)
        target_?.addSubview(scrollView)
    }
    
    internal lazy var scrollView: _internal_SKScrollView = {
        let scv = _internal_SKScrollView(frame: CGRect(origin: .zero, size: size))
        scv.contentSize = size
        scv.delegate = scrollViewDelegateProxy
        return scv
    }()
    
    open override var position: CGPoint {
        didSet {
            guard let target = target_ else { return }
            scrollView.center = target._internal_convert(.zero, from: self)
        }
    }
    
    open var size: CGSize {
        didSet {
            backgroundNode.size = size
            scrollView.frame = scrollView.bounds._internal_reset(size: size)
        }
    }
    
    open var contentOffset: CGPoint {
        get { return scrollView.contentOffset }
        set { scrollView.contentOffset = newValue }
    }
    
    open var contentSize: CGSize {
        get { return scrollView.contentSize }
        set { scrollView.contentSize = newValue }
    }
    
    open var contentInset: SKEdgeInsets {
        get { return scrollView.contentInset }
        set { scrollView.contentInset = newValue }
    }
    
    @available(iOS 11.0, *)
    open var adjustedContentInset: SKEdgeInsets {
        return scrollView.adjustedContentInset
    }
    
    @available(iOS 11.0, *)
    open func adjustedContentInsetDidChange() {
        scrollView.adjustedContentInsetDidChange()
    }
    
    @available(iOS 11.0, *)
    open var contentInsetAdjustmentBehavior: SKScrollNodeContentInsetAdjustmentBehavior {
        get { return scrollView.contentInsetAdjustmentBehavior }
        set { scrollView.contentInsetAdjustmentBehavior = newValue }
    }
    
    open var isDirectionalLockEnabled: Bool {
        get { return scrollView.isDirectionalLockEnabled }
        set { scrollView.isDirectionalLockEnabled = newValue }
    }
    
    open var bounces: Bool {
        get { return scrollView.bounces }
        set { scrollView.bounces = newValue }
    }
    
    open var alwaysBounceVertical: Bool {
        get { return scrollView.alwaysBounceVertical }
        set { scrollView.alwaysBounceVertical = newValue }
    }
    
    open var alwaysBounceHorizontal: Bool {
        get { return scrollView.alwaysBounceHorizontal }
        set { scrollView.alwaysBounceHorizontal = newValue }
    }
    
    open var isPagingEnabled: Bool {
        get { return scrollView.isPagingEnabled }
        set { scrollView.isPagingEnabled = newValue }
    }
    
    open var isScrollEnabled: Bool {
        get { return scrollView.isScrollEnabled }
        set { scrollView.isScrollEnabled = newValue }
    }
    
    open var showsHorizontalScrollIndicator: Bool {
        get { return scrollView.showsHorizontalScrollIndicator }
        set { scrollView.showsHorizontalScrollIndicator = newValue }
    }
    
    open var showsVerticalScrollIndicator: Bool {
        get { return scrollView.showsVerticalScrollIndicator }
        set { scrollView.showsVerticalScrollIndicator = newValue }
    }
    
    open var scrollIndicatorInsets: SKEdgeInsets {
        get { return scrollView.scrollIndicatorInsets }
        set { scrollView.scrollIndicatorInsets = newValue }
    }
    
    open var indicatorStyle: SKScrollNodeIndicatorStyle {
        get { return scrollView.indicatorStyle }
        set { scrollView.indicatorStyle = newValue }
    }
    
    @available(iOS 3.0, *)
    open var decelerationRate: CGFloat {
        get { return scrollView.decelerationRate }
        set { scrollView.decelerationRate = newValue }
    }
    
    open func setContentOffset(_ contentOffset: CGPoint, animated: Bool) {
        scrollView.setContentOffset(contentOffset, animated: animated)
    }
    
    open func scrollRectToVisible(_ rect: CGRect, animated: Bool) {
        scrollView.scrollRectToVisible(rect, animated: animated)
    }
    
    open func flashScrollIndicators() {
        scrollView.flashScrollIndicators()
    }
    
    open var isTracking: Bool {
        return scrollView.isTracking
    }
    
    open var isDragging: Bool {
        return scrollView.isDragging
    }
    
    open var isDecelerating: Bool {
        return scrollView.isDecelerating
    }
    
    open var delaysContentTouches: Bool {
        get { return scrollView.delaysContentTouches }
        set { scrollView.delaysContentTouches = newValue }
    }
    
    open var canCancelContentTouches: Bool {
        get { return scrollView.canCancelContentTouches }
        set { scrollView.canCancelContentTouches = newValue }
    }
    
    open var scrollsToTop: Bool {
        get { return scrollView.scrollsToTop }
        set { scrollView.scrollsToTop = newValue }
    }
    
    @available(iOS 5.0, *)
    open var panGestureRecognizer: UIPanGestureRecognizer {
        return scrollView.panGestureRecognizer
    }
    
    @available(iOS 5.0, *)
    open var pinchGestureRecognizer: UIPinchGestureRecognizer? {
        return scrollView.pinchGestureRecognizer
    }
    
    open var directionalPressGestureRecognizer: UIGestureRecognizer {
        return scrollView.directionalPressGestureRecognizer
    }
    
    @available(iOS 7.0, *)
    open var keyboardDismissMode: SKScrollNodeKeyboardDismissMode {
        get { return scrollView.keyboardDismissMode }
        set { scrollView.keyboardDismissMode = newValue }
    }
    
    internal func _proxyScrollViewDidScroll(_ scrollView: UIScrollView) {
        contentNode.position = CGPoint(x: -scrollView.contentOffset.x, y: scrollView.contentOffset.y)
    }
}

// MARK: _Private_ScrollNode_ScrollView_Delegate
extension SKScrollNode: _Private_ScrollNode_ScrollView_Delegate {
    
    func _proxy_scrollViewDidScroll(proxy: _Scroll_Delegate_Proxy_, _ scrollView: UIScrollView) {
        _proxyScrollViewDidScroll(scrollView)
        scrollDelegate?.scrollNodeDidScroll?(self)
    }
    
    func _proxy_scrollViewWillBeginDragging(proxy: _Scroll_Delegate_Proxy_, _ scrollView: UIScrollView) {
        scrollDelegate?.scrollNodeWillBeginDragging?(self)
    }
    
    func _proxy_scrollViewWillEndDragging(proxy: _Scroll_Delegate_Proxy_, _ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollDelegate?.scrollNodeWillEndDragging?(self, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    func _proxy_scrollViewDidEndDragging(proxy: _Scroll_Delegate_Proxy_, _ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollDelegate?.scrollNodeDidEndDragging?(self, willDecelerate: decelerate)
    }
    
    func _proxy_scrollViewWillBeginDecelerating(proxy: _Scroll_Delegate_Proxy_, _ scrollView: UIScrollView) {
        scrollDelegate?.scrollNodeWillBeginDecelerating?(self)
    }
    
    func _proxy_scrollViewDidEndDecelerating(proxy: _Scroll_Delegate_Proxy_, _ scrollView: UIScrollView) {
        scrollDelegate?.scrollNodeDidEndDecelerating?(self)
    }
    
    func _proxy_scrollViewDidEndScrollingAnimation(proxy: _Scroll_Delegate_Proxy_, _ scrollView: UIScrollView) {
        scrollDelegate?.scrollNodeDidEndScrollingAnimation?(self)
    }
    
    func _proxy_scrollViewShouldScrollToTop(proxy: _Scroll_Delegate_Proxy_, _ scrollView: UIScrollView) -> Bool {
        return scrollDelegate?.scrollNodeShouldScrollToTop?(self) ?? true
    }
    
    func _proxy_scrollViewDidScrollToTop(proxy: _Scroll_Delegate_Proxy_, _ scrollView: UIScrollView) {
        scrollDelegate?.scrollNodeDidScrollToTop?(self)
    }
    
    @available(iOS 11.0, *)
    func _proxy_scrollViewDidChangeAdjustedContentInset(proxy: _Scroll_Delegate_Proxy_, _ scrollView: UIScrollView) {
        scrollDelegate?.scrollNodeDidChangeAdjustedContentInset?(self)
    }
}

protocol _Private_ScrollNode_ScrollView_Delegate: NSObjectProtocol {
    func _proxy_scrollViewDidScroll(proxy: _Scroll_Delegate_Proxy_, _ scrollView: UIScrollView)
    
    func _proxy_scrollViewWillBeginDragging(proxy: _Scroll_Delegate_Proxy_, _ scrollView: UIScrollView)
    
    func _proxy_scrollViewWillEndDragging(proxy: _Scroll_Delegate_Proxy_, _ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    
    func _proxy_scrollViewDidEndDragging(proxy: _Scroll_Delegate_Proxy_, _ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    
    func _proxy_scrollViewWillBeginDecelerating(proxy: _Scroll_Delegate_Proxy_, _ scrollView: UIScrollView)
    
    func _proxy_scrollViewDidEndDecelerating(proxy: _Scroll_Delegate_Proxy_, _ scrollView: UIScrollView)
    
    func _proxy_scrollViewDidEndScrollingAnimation(proxy: _Scroll_Delegate_Proxy_, _ scrollView: UIScrollView)
    
    func _proxy_scrollViewShouldScrollToTop(proxy: _Scroll_Delegate_Proxy_, _ scrollView: UIScrollView) -> Bool
    
    func _proxy_scrollViewDidScrollToTop(proxy: _Scroll_Delegate_Proxy_, _ scrollView: UIScrollView)
    
    @available(iOS 11.0, *)
    func _proxy_scrollViewDidChangeAdjustedContentInset(proxy: _Scroll_Delegate_Proxy_, _ scrollView: UIScrollView)
}

class _Scroll_Delegate_Proxy_: NSObject, UIScrollViewDelegate {
    
    weak var delegate: _Private_ScrollNode_ScrollView_Delegate?
    
    // MARK: UIScrollViewDelegate
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?._proxy_scrollViewDidScroll(proxy: self, scrollView)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?._proxy_scrollViewWillBeginDragging(proxy: self, scrollView)
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        delegate?._proxy_scrollViewWillEndDragging(proxy: self, scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?._proxy_scrollViewDidEndDragging(proxy: self, scrollView, willDecelerate: decelerate)
    }
    
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        delegate?._proxy_scrollViewWillBeginDecelerating(proxy: self, scrollView)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?._proxy_scrollViewDidEndDecelerating(proxy: self, scrollView)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        delegate?._proxy_scrollViewDidEndScrollingAnimation(proxy: self, scrollView)
    }
    
    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return delegate?._proxy_scrollViewShouldScrollToTop(proxy: self, scrollView) ?? true
    }
    
    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        delegate?._proxy_scrollViewDidScrollToTop(proxy: self, scrollView)
    }
    
    @available(iOS 11.0, *)
    public func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        delegate?._proxy_scrollViewDidChangeAdjustedContentInset(proxy: self, scrollView)
    }
}

public typealias SKEdgeInsets = UIEdgeInsets
public typealias SKScrollNodeIndicatorStyle = UIScrollViewIndicatorStyle
public typealias SKScrollNodeKeyboardDismissMode = UIScrollViewKeyboardDismissMode

@available(iOS 11.0, *)
public typealias SKScrollNodeContentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior

@objc public protocol SKScrollNodeDelegate : NSObjectProtocol {
    
    @objc @available(iOS 2.0, *)
    optional func scrollNodeDidScroll(_ scrollNode: SKScrollNode)
    
    @objc @available(iOS 2.0, *)
    optional func scrollNodeWillBeginDragging(_ scrollNode: SKScrollNode)
    
    @objc @available(iOS 5.0, *)
    optional func scrollNodeWillEndDragging(_ scrollNode: SKScrollNode, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    
    @objc @available(iOS 2.0, *)
    optional func scrollNodeDidEndDragging(_ scrollNode: SKScrollNode, willDecelerate decelerate: Bool)
    
    @objc @available(iOS 2.0, *)
    optional func scrollNodeWillBeginDecelerating(_ scrollNode: SKScrollNode)
    
    @objc @available(iOS 2.0, *)
    optional func scrollNodeDidEndDecelerating(_ scrollNode: SKScrollNode)
    
    @objc @available(iOS 2.0, *)
    optional func scrollNodeDidEndScrollingAnimation(_ scrollNode: SKScrollNode)
    
    @objc @available(iOS 2.0, *)
    optional func scrollNodeShouldScrollToTop(_ scrollNode: SKScrollNode) -> Bool
    
    @objc @available(iOS 2.0, *)
    optional func scrollNodeDidScrollToTop(_ scrollNode: SKScrollNode)
    
    @objc @available(iOS 11.0, *)
    optional func scrollNodeDidChangeAdjustedContentInset(_ scrollNode: SKScrollNode)
}

internal class _internal_SKScrollView: UIScrollView {
    
    fileprivate weak var eventProxy: UIResponder?
    
    // MARK: Proxy
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        eventProxy?.touchesBegan(touches, with: event)
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        eventProxy?.touchesMoved(touches, with: event)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        eventProxy?.touchesEnded(touches, with: event)
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        eventProxy?.touchesCancelled(touches, with: event)
    }
    
    @available(iOS 9.1, *)
    open override func touchesEstimatedPropertiesUpdated(_ touches: Set<UITouch>) {
        super.touchesEstimatedPropertiesUpdated(touches)
        eventProxy?.touchesEstimatedPropertiesUpdated(touches)
    }
    
    open override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        super.pressesBegan(presses, with: event)
        eventProxy?.pressesBegan(presses, with: event)
    }
    
    open override func pressesChanged(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        super.pressesChanged(presses, with: event)
        eventProxy?.pressesChanged(presses, with: event)
    }
    
    open override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        super.pressesEnded(presses, with: event)
        eventProxy?.pressesEnded(presses, with: event)
    }
    
    open override func pressesCancelled(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        super.pressesCancelled(presses, with: event)
        eventProxy?.pressesCancelled(presses, with: event)
    }
    
    open override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        super.motionBegan(motion, with: event)
        eventProxy?.motionBegan(motion, with: event)
    }
    
    open override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        eventProxy?.motionEnded(motion, with: event)
    }
    
    open override func motionCancelled(_ motion: UIEventSubtype, with event: UIEvent?) {
        super.motionCancelled(motion, with: event)
        eventProxy?.motionCancelled(motion, with: event)
    }
    
    open override func remoteControlReceived(with event: UIEvent?) {
        super.remoteControlReceived(with: event)
        eventProxy?.remoteControlReceived(with: event)
    }
}
