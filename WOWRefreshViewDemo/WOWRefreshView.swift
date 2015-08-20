//
//  WOWRefreshView.swift
//  WOWRefreshViewDemo
//
//  To replace the UIRefreshControl mainly because it's more flexible
//
//  Created by Zhou Hao on 19/8/15.
//  Copyright © 2015 Zhou Hao. All rights reserved.
//

// TODO: 1. Decide the direction automatically
//       2. Pull from any side of the screen
//       3. Decouple the animation from the refresh view, support any animation who follow the certain protocol

import UIKit

public class WOWRefreshView: UIView {

    // MARK: definitions
    typealias RefreshHandler = () -> Void
    public enum ScrollDirection {
        case None   // initial state
        case Right  // pull right
        case Down   // pull down
        case Up     // pull up
        case Left   // pull left
    }
    
    // MARK: constants
    private let kIndicatorWidth         : CGFloat = 40.0
    private let kPadding                : CGFloat = 20.0
    private let kThrehold               : CGFloat = 20.0
    
    // MARK: private properties
    private var scrollDirection : ScrollDirection = .None
    private var scrollView      : UIScrollView!
    private var refreshHandler  : RefreshHandler!
    private var rippleIndicator : WOWRippleIndicator?
    private var refreshing      : Bool = false
    private var readyToRefresh  : Bool = false
    
    // MARK: initialization
    public init(scrollView : UIScrollView, direction : ScrollDirection, completion refreshHandler: (()->Void)) {
        super.init(frame: CGRectZero)

        self.scrollView = scrollView
        self.refreshHandler = refreshHandler
        self.scrollDirection = direction
        
        scrollView.addObserver(self, forKeyPath: "contentOffset",options: [.New,.Old], context: nil)
        scrollView.addSubview(self)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("call init(ScrollView...) instead")
    }
    
    init() {
        fatalError("call init(ScrollView...) instead")
    }
    
    override init(frame: CGRect) {
        fatalError("call init(ScrollView...) instead")
    }
    
    deinit {
        scrollView.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    // MARK: public methods
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        print("scrollView.contentOffset=\(scrollView.contentOffset)")
        
        let offset = scrollDirection == .Down ? scrollView.contentOffset.y : scrollView.contentOffset.x
        let w = scrollDirection == .Down ? scrollView.frame.size.width : offset
        let h = scrollDirection == .Down ? offset :scrollView.frame.size.height
        
        self.frame = CGRectMake(0, 0, w, h)
        print(frame)
        
        if offset <= -kIndicatorWidth {
            
            if !refreshing {
                let percentage = min(1,(-offset - kIndicatorWidth) / kIndicatorWidth)
                createIndicator()
                
                rippleIndicator!.degree = percentage
                readyToRefresh = percentage == 1
                
                if offset < -2*kIndicatorWidth {
                    readyToRefresh = true
                }
            }
            
            let center = scrollDirection == .Down ? CGPointMake(self.center.x - kIndicatorWidth / 2, -self.center.y - kIndicatorWidth / 2) : CGPointMake(-self.center.x - kIndicatorWidth / 2, self.center.y - kIndicatorWidth / 2)
            rippleIndicator!.frame = CGRect(origin: center, size: rippleIndicator!.bounds.size)
            
            let threhold = (2 * kIndicatorWidth + kPadding)
            if offset < -threhold {
                self.scrollView.contentOffset = scrollDirection == .Down ? CGPointMake(0, -threhold) : CGPointMake(-threhold,0)
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
            scrollView.contentInset = scrollDirection == .Down ? UIEdgeInsetsMake(offset, 0, 0, 0) : UIEdgeInsetsMake(0, offset, 0, 0)
            let point = scrollDirection == .Down ? CGPointMake(0, -offset) : CGPointMake(-offset,0)
            scrollView.setContentOffset(point, animated: true)
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
            rippleIndicator!.rippleColor = self.tintColor == nil ? UIColor.darkGrayColor() : self.tintColor!
            rippleIndicator!.rippleLineWidth = 2
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
