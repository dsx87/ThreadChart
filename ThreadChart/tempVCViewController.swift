//
//  tempVCViewController.swift
//  ThreadChart
//
//  Created by Igor Pivnyk on 16.12.2017.
//  Copyright © 2017 Igor Pivnyk. All rights reserved.
//

import UIKit

class tempVCViewController: UIViewController {
    
    var menu:Menu!
    var touchedView:UIView!
    @IBOutlet weak var label:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
   
    func addMenu(at position:CGPoint) {
        let size:CGFloat = 200.0
        menu = Menu()
        /*let label = UILabel()
        label.frame = CGRect.zero
        label.text = "Test"
        label.textAlignment = .center
        label.backgroundColor = UIColor.gray        
        menu.addSubview(label)
        */
        menu.addItem(named: "addedItem")
        menu.frame = CGRect(x: position.x - size/2,
                            y: position.y - size/2,
                            width: size, height: size)
        
        
        
        view.addSubview(menu)
    }
    
    @objc func hideMenu() {
        menu?.hide()
        menu = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let coord = touch.location(in: nil)
        if label.frame.contains(coord){
            addMenu(at: label.center)
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let menu = self.menu else { return }
        
        let touch = touches.first!
        let touchPos = touch.location(in: menu)
        for view in menu.subviews{
            if view.frame.contains(touchPos){
                print("YEAH!!!!")
            }
        }
        hideMenu()
    }
}
