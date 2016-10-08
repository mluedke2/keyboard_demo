//
//  ForceTouchGestureRecognizer.swift
//  MyCustomKeyboard
//
//  Created by Matt Luedke on 10/7/16.
//  Copyright © 2016 exygy. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

class ForceTouchGestureRecognizer: UIGestureRecognizer {
    
    private(set) var forceValue: CGFloat? // value between 0.0 - 1.0
    
    var touchDownTime: NSDate?
    var text: String?
    
    var minimumValue: CGFloat = 0 // Value between 0.0 - 1.0 that needs to be reached before gesture begins
    var tolerance: CGFloat = 1 // Once force drops below maxValue - tolerance, the gesture ends
    
    private var maxValue: CGFloat = 0
    
    override func reset() {
        super.reset()
        forceValue = nil
        maxValue = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        if #available(iOS 9.0, *) {
            if touches.count != 1 {
                state = .failed
            }
        }
        
        touchDownTime = NSDate()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        if #available(iOS 9.0, *) {
            
            let touch = touches.first!
            let value = touch.force / touch.maximumPossibleForce
            
            if state == .possible {
                
                if value > minimumValue {
                    state = .began
                }
            } else {
                
                if value < (maxValue - tolerance) {
                    state = .ended
                } else {
                    maxValue = max(self.forceValue ?? 0, maxValue)
                    self.forceValue = value
                    state = .changed
                }
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        if state == .began || state == .changed {
            state = .cancelled
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        if state == .began || state == .changed {
            state = .ended
        }
        print("touch length: \(-touchDownTime!.timeIntervalSinceNow)")
        touchDownTime = nil
    }
}
