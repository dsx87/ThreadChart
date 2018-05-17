//
//  HelpButton.swift
//  ThreadChart
//
//  Created by Igor Pivnyk on 02.05.2018.
//  Copyright © 2018 Igor Pivnyk. All rights reserved.
//

import UIKit

class HelpButton: UIButton {
    
    override func awakeFromNib() {
        backgroundColor = UIColor.clear
        layer.bounds.size = CGSize(width: 25.0, height: 25.0)
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = self.frame.size.height / 2
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
