//
//  ViewControllerView.swift
//  ThreadChart
//
//  Created by Igor Pivnyk on 20.05.2018.
//  Copyright © 2018 Igor Pivnyk. All rights reserved.
//

import UIKit


class ViewControllerView: UIView {
    let gradient = CAGradientLayer()
    
    override func awakeFromNib() {
        gradient.frame = self.bounds
        self.backgroundColor = UIColor.clear
    }
    
    //setting view specific appearance
    
    func setISOView() -> UIColor {
        let startColor = UIColor(red: 1/255, green: 117/255, blue: 225/255, alpha: 1.0)
        let finishColor = UIColor(red: 2/255, green: 100/255, blue: 191/255, alpha: 1.0)
        gradient.colors = [startColor.cgColor, finishColor.cgColor]
        self.layer.insertSublayer(gradient, at: 0)
        return startColor
    }
    
    func setBSPPView() -> UIColor {
        let startColor = UIColor(red: 104/255, green: 90/255, blue: 215/255, alpha: 1.0)
        let finishColor = UIColor(red: 103/255, green: 89/255, blue: 208/255, alpha: 1.0)
        gradient.colors = [startColor.cgColor, finishColor.cgColor]
        self.layer.insertSublayer(gradient, at: 0)
        return startColor
    }
    
    func setUNView() -> UIColor {
        let startColor = UIColor(red: 232/255, green: 22/255, blue: 104/255, alpha: 1.0)
        let finishColor = UIColor(red: 218/255, green: 33/255, blue: 105/255, alpha: 1.0)
        gradient.colors = [startColor.cgColor, finishColor.cgColor]
        self.layer.insertSublayer(gradient, at: 0)
        return startColor
    }
}
