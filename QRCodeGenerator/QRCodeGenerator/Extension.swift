//
//  Extension.swift
//  QRCodeGenerator
//
//  Created by MYK on 16/11/16.
//  Copyright © 2016年 MYK. All rights reserved.
//

import Foundation
import UIKit


// MARK: -String extension
extension String {
    // readOnly computed
    var length: Int {
        return self.characters.count
    }
    
    func trim() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
    func substring(location: Int, length: Int) -> String {
        return (self as NSString).substringWithRange(NSRange(location:location, length: length))
    }
    
}



// MARK: - UIView extension
extension UIView {
    
    // 从nib加载view
    class func loadFromNibNamed(nibNamed: String, bundle: NSBundle? = nil) -> UIView? {
        return UINib(nibName: nibNamed, bundle: bundle).instantiateWithOwner(nil, options: nil)[0] as? UIView
    }
    
    // 删除所有的subviews
    func removeAllSubviews() {
        for subview: AnyObject in self.subviews {
            subview.removeFromSuperview()
        }
    }
}
