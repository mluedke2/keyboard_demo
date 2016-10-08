//
//  KeyboardViewController.swift
//  MyKeyboard
//
//  Created by Matt Luedke on 10/7/16.
//  Copyright © 2016 exygy. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {

    @IBOutlet var nextKeyboardButton: UIButton!
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Perform custom UI setup here
        self.nextKeyboardButton = UIButton(type: .system)
        
        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), for: [])
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        
        self.view.addSubview(self.nextKeyboardButton)
        
        self.nextKeyboardButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.nextKeyboardButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
      
        // above here is template
        let buttonTitles = ["Q", "W", "E", "R", "T", "Y"]
        let buttons = createButtons(titles: buttonTitles)
        let topRow = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        
        for button in buttons {
            topRow.addSubview(button)
        }
        
        self.view.addSubview(topRow)
        
        addConstraints(buttons: buttons, containingView: topRow)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let parentViewController = self.parent {
            let hostBundleID = parentViewController.value(forKey: "_hostBundleID")
            print(hostBundleID)
        }
    }
  
    func createButtons(titles: [String]) -> [UILabel] {
        
        var buttons = [UILabel]()
        
        for title in titles {
            let button = UILabel()
            button.text = title
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
            button.textColor = UIColor.darkGray
            button.isUserInteractionEnabled = true
            
            
            let forceTouchGesture = ForceTouchGestureRecognizer(target: self, action: #selector(KeyboardViewController.keyPressed(recognizer:)))
            forceTouchGesture.text = title
            forceTouchGesture.minimumValue = 0.1
            forceTouchGesture.tolerance = 0.2
            button.addGestureRecognizer(forceTouchGesture)
            buttons.append(button)
        }
        
        return buttons
    }
    
    func keyPressed(recognizer: ForceTouchGestureRecognizer) {
        // needed to actually use text input in app
//        (textDocumentProxy as UIKeyInput).insertText(title!)
        
        if let title = recognizer.text, let force = recognizer.forceValue {
            print("force on letter \(title): \(force)")  // force is CGFloat between 0 & 1
        }
    }
    
    func addConstraints(buttons: [UILabel], containingView: UIView){
        
        for (index, button) in buttons.enumerated() {
            
            let topConstraint = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: containingView, attribute: .top, multiplier: 1.0, constant: 1)
            
            let bottomConstraint = NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: containingView, attribute: .bottom, multiplier: 1.0, constant: -1)
            
            var leftConstraint : NSLayoutConstraint!
            
            if index == 0 {
                
                leftConstraint = NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: containingView, attribute: .left, multiplier: 1.0, constant: 1)
                
            } else {
                
                leftConstraint = NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: buttons[index-1], attribute: .right, multiplier: 1.0, constant: 1)
                
                let widthConstraint = NSLayoutConstraint(item: buttons[0], attribute: .width, relatedBy: .equal, toItem: button, attribute: .width, multiplier: 1.0, constant: 0)
                
                containingView.addConstraint(widthConstraint)
            }
            
            var rightConstraint : NSLayoutConstraint!
            
            if index == buttons.count - 1 {
                
                rightConstraint = NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: containingView, attribute: .right, multiplier: 1.0, constant: -1)
                
            }else{
                
                rightConstraint = NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: buttons[index+1], attribute: .left, multiplier: 1.0, constant: -1)
            }
            
            containingView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
        }
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
        self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }

}
