//
//  WOWRefreshView.swift
//  WOWRefreshViewDemo
//
//  To replace the UIRefreshControl mainly because it's more flexible
//
//  Created by Zhou Hao on 19/8/15.
//  Copyright © 2015 Zhou Hao. All rights reserved.
//

import UIKit

public class WOWRefreshView: UIView {

    // MARK: definitions
    typealias RefreshHandler = () -> Void
    enum ScrollDirection {
        case Horizontal
        case Vertical
    }
    
    // MARK: public properties
    public var lineWidth : CGFloat = 2.0
    public var lineColor : UIColor = UIColor.blackColor()
    
    // MARK: constants
    private let kIndicatorWidth         : CGFloat = 40.0
    private let kPadding                : CGFloat = 20.0
    private let kThrehold               : CGFloat = 20.0
    
    // MARK: private properties
    private var scrollDirection : ScrollDirection = .Vertical
    private var scrollView : UIScrollView!
    private var refreshHandler : RefreshHandler!
    private var rippleIndicator : WOWRippleIndicator?
    private var refreshing  : Bool = false {
        didSet {
            scrollView.pagingEnabled = !refreshing
            scrollView.scrollEnabled = !refreshing
        }
    }
    private var readyToRefresh : Bool = false {
        didSet {
            if readyToRefresh {
                // show label release to refresh

            }
        }
    }
    
    // MARK: initialization
    public init(scrollView : UIScrollView, completion refreshHandler: (()->Void)) {
        super.init(frame: CGRectZero)

        self.scrollView = scrollView
        self.refreshHandler = refreshHandler
        self.frame = CGRectMake(0,0,scrollView.frame.size.width,0)
        
        //self.backgroundColor = UIColor.yellowColor()
        scrollView.addObserver(self, forKeyPath: "contentOffset",options: [.New,.Old], context: nil)
        scrollView.addSubview(self)
    }

    // TODO: other init
    required public init?(coder aDecoder: NSCoder) {
        fatalError("call init(ScrollView...) instead")
    }
    
    // MARK: public methods
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        print(scrollView.contentOffset)
        self.frame = CGRectMake(0, 0,
            scrollView.frame.size.width, scrollView.contentOffset.y)
        
        if self.scrollView.contentOffset.y <= -kIndicatorWidth {
            
            if !refreshing {
                let percentage = min(1,(-self.scrollView.contentOffset.y - kIndicatorWidth) / kIndicatorWidth)
                createIndicator()
                
                rippleIndicator!.degree = percentage
                readyToRefresh = percentage == 1
                
                if scrollView.contentOffset.y < -2*kIndicatorWidth {
                    readyToRefresh = true
                }
            }
            
            let center = CGPointMake(self.center.x - kIndicatorWidth / 2, -self.center.y - kIndicatorWidth / 2)
            rippleIndicator!.frame = CGRect(origin: center, size: rippleIndicator!.bounds.size)
            
            let offset = (2 * kIndicatorWidth + kPadding)
            if self.scrollView.contentOffset.y < -offset {
                self.scrollView.contentOffset = CGPointMake(0, -offset)
            }
        } else {
            removeIndicator()
        }
        
        if !scrollView.dragging && scrollView.decelerating && readyToRefresh {
            startRefreshing()
        }
    }
    
    public func startRefreshing() {
    
        if !refreshing {
            let offset = 2 * kIndicatorWidth
            scrollView.contentInset = UIEdgeInsetsMake(offset, 0, 0, 0)
            scrollView.setContentOffset(CGPointMake(0, -offset), animated: true)
            refresh()
        }
    }
    
    public func endRefreshing() {

        if refreshing {
            refreshing = false
            if scrollView.contentOffset.y > -2 * kIndicatorWidth {
                GCD.delay(0.8, block: { () -> () in
                    self.returnToDefaultState()
                })
            } else {
                returnToDefaultState()
            }
        }
    }
    
    // MARK: internal methods
    func returnToDefaultState() {
    
        UIView.animateWithDuration(0.8, delay: 0,
            usingSpringWithDamping: 0.4,
            initialSpringVelocity: 0.8,
            options: .CurveLinear,
            animations: {
                () -> Void in
                self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            }, completion: nil)
    }
    
    func createIndicator() {
        
        if rippleIndicator == nil {
            rippleIndicator = WOWRippleIndicator()
            rippleIndicator!.bounds = CGRect(origin: CGPointZero, size: CGSizeMake(kIndicatorWidth, kIndicatorWidth))
            rippleIndicator!.backgroundColor = UIColor.clearColor()
            rippleIndicator!.degree = 0
            rippleIndicator!.rippleColor = self.lineColor
            rippleIndicator!.rippleLineWidth = self.lineWidth
            self.addSubview(rippleIndicator!)
        }
    }
    
    func removeIndicator() {
        
        if rippleIndicator != nil {
            rippleIndicator!.removeFromSuperview()
            rippleIndicator = nil
        }
    }
    
    func refresh() {
        
        if !refreshing {
            if rippleIndicator != nil {
                rippleIndicator!.degree = 0
                rippleIndicator!.startAnimation()
            }
            if refreshHandler != nil {
                refreshHandler!()
            }
            
            readyToRefresh = false
            refreshing = true            
        }
    }
    
}
