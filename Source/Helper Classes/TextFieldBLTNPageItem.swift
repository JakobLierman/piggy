//
//  TextFieldBLTNPageItem.swift
//  Piggy
//
//  Created by Jakob Lierman on 06/05/2020.
//  Copyright © 2020 Jakob Lierman. All rights reserved.
//

import UIKit
import BLTNBoard

class TextFieldBLTNPageItem: BLTNPageItem {
    
    public var textField: UITextField!
    public var textInputHandler: ((BLTNActionItem, String?) -> Void)? = nil
    
    override func makeViewsUnderTitle(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        textField = interfaceBuilder.makeTextField(placeholder: "Name", returnKey: .done, delegate: self)
        return [textField]
    }
    
    override func tearDown() {
        super.tearDown()
        textField?.delegate = nil
    }
    
    override func actionButtonTapped(sender: UIButton) {
        textField.resignFirstResponder()
        super.actionButtonTapped(sender: sender)
    }

}

extension TextFieldBLTNPageItem: UITextFieldDelegate {
    
    open func isInputValid(text: String?) -> Bool {
        if text == nil || text!.isEmpty {
            return false
        }
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if isInputValid(text: textField.text) {
            textInputHandler?(self, textField.text)
        } else {
            descriptionLabel?.textColor = .red
            descriptionLabel?.text = "Enter your name to continue or skip this step."
            textField.layer.borderWidth = 2
            textField.layer.borderColor = UIColor.red.cgColor
            textField.layer.cornerRadius = 6.0
        }
    }
    
}
