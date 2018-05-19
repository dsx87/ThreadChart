//
//  ViewExtension.swift
//  ThreadChart
//
//  Created by Igor Pivnyk on 19.05.2018.
//  Copyright © 2018 Igor Pivnyk. All rights reserved.
//

import UIKit


extension UIView {
    func setTextFieldsDelegate(to vc:UIViewController) {
        for view in self.subviews {
            if let view = view as? UITextField  {
                view.delegate = vc as? UITextFieldDelegate
            }
        }
    }
    
    func unsetTextFieldsDelegate(){
        for view in self.subviews {
            if let view = view as? UITextField  {
                view.text = ""
                view.delegate = nil
            }
        }
    }
    
    func resignFirstResponderFromSubviews() {
        self.subviews.forEach{ view in
            view.resignFirstResponder()
        }
    }
}
