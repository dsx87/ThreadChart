//
//  Menu.swift
//  ThreadChart
//
//  Created by Igor Pivnyk on 16.12.2017.
//  Copyright © 2017 Igor Pivnyk. All rights reserved.
//

import UIKit

class Menu: UIView {
    
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "self.frame"{
            setLayer(size: self.frame.size)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        if frame != CGRect.zero{
            setLayer(size: frame.size)
        }else{
            addObserver(self, forKeyPath: "self.frame", context: nil)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayer(size:CGSize){
        layer.bounds.size = CGSize.zero
        layer.cornerRadius = self.layer.frame.width / 2
        layer.backgroundColor = UIColor.blue.cgColor
        
        UIView.animate(withDuration: 0.3){
            self.layer.bounds.size = size
            self.layer.cornerRadius = self.layer.frame.width / 2
            
        }
        setSubviews()
        
        
    }
    
    
    func hide(){
        let animation:() -> Void = {
            self.layer.bounds.size = CGSize.zero
            self.layer.cornerRadius = self.layer.frame.width / 2
            for view in self.subviews{
                view.frame = CGRect.zero
            }
        }
        
        UIView.animate(withDuration: 0.3, animations: animation){ finished in
            self.removeFromSuperview()
        }
    }
    
    private func setSubviews(){
        let subviewsCoords = arrangeSubViews()
        UIView.animate(withDuration: 0.3){
            for (index,view) in self.subviews.enumerated(){
                view.frame = subviewsCoords[index]
            }
        }
        
    }
    
    private func arrangeSubViews() -> [CGRect]{
        var array = [CGRect]()
        let subviewSize = CGSize(width: 70, height: 30)
        var theta:CGFloat = 1.0
        let angle:CGFloat = (.pi)/CGFloat(subviews.count)
        let radius = frame.width/2
        let centerPoint = CGPoint(x: bounds.midX, y: bounds.midY)
        for (index,_) in subviews.enumerated() {
            
            theta = CGFloat(index) * angle
            let centerX = centerPoint.x + radius * cos(theta)
            let centerY = centerPoint.y + radius * sin(theta)
            
            let rect = CGRect(x: centerX - subviewSize.width,
                              y: centerY - subviewSize.height/2,
                              width: subviewSize.width, height: subviewSize.height)
            array.append(rect)
        }
        return array
    }
    
    func addItem(named:String){
        let label = UILabel()
        label.frame = CGRect.zero
        label.text = named
        label.textAlignment = .center
        label.backgroundColor = UIColor.clear
        label.layer.cornerRadius = label.layer.frame.width / 2
        addSubview(label)
    }
  
}
