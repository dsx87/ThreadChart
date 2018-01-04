//
//  StandardViewController.swift
//  ThreadChart
//
//  Created by dsx on 19.12.17.
//  Copyright © 2017 Igor Pivnyk. All rights reserved.
//

import UIKit

class StandardViewController: UIViewController {
    
    @IBOutlet weak var isoButton: UIButton!

    @IBOutlet weak var unButton: UIButton!
    
    
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let standardNames = [
        Thread.ThreadStandard.iso:"ISO",
        Thread.ThreadStandard.un:"UN"
    ]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isoButton.layer.borderWidth = 0.5
        isoButton.layer.borderColor = UIColor.darkGray.cgColor
        
        unButton.layer.borderWidth = 0.5
        unButton.layer.borderColor = UIColor.darkGray.cgColor
        

        
    }

  
    

    
   
 
    @IBAction func isoButtonAction(_ sender: UIButton) {
        appDelegate.threadParams[.standard] = Thread.ThreadStandard.iso
        performSegue(withIdentifier: "inOutSegue", sender: sender)
        
    }
    @IBAction func unButtonAction(_ sender: UIButton) {
        appDelegate.threadParams[.standard] = Thread.ThreadStandard.un
        performSegue(withIdentifier: "inOutSegue", sender: sender)
    }
    

   
}









