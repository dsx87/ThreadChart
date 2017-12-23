//
//  InternalExternalViewController.swift
//  ThreadChart
//
//  Created by dsx on 19.12.17.
//  Copyright © 2017 Igor Pivnyk. All rights reserved.
//

import UIKit

class InExViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var exButton: UIButton!
    @IBOutlet weak var inButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exButton.layer.borderWidth = 0.5
        exButton.layer.borderColor = UIColor.darkGray.cgColor
        
        inButton.layer.borderWidth = 0.5
        inButton.layer.borderColor = UIColor.darkGray.cgColor
    }

    
    
    @IBAction func externalButtonAction(_ sender: UIButton) {
        appDelegate.threadParams[.isInternal] = false
        performSegue(withIdentifier: "parametersSegue", sender: nil)
    }

    @IBAction func internalButtonAction(_ sender: UIButton) {
        appDelegate.threadParams[.isInternal] = true
        performSegue(withIdentifier: "parametersSegue", sender: nil)
    }
 
}
