//
//  TextInputField.swift
//  Lesson_19_05_24_Firebase
//
//  Created by Aykhan Hajiyev on 19.05.24.
//

import UIKit


class InsetTextField: UITextField {
    
    var inset: CGFloat = 10
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: inset, dy: inset)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: inset, dy: inset)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: inset, dy: inset)
    }
}
