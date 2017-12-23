//
//  InternalThreadViewController.swift
//  ThreadChart
//
//  Created by dsx on 19.12.17.
//  Copyright © 2017 Igor Pivnyk. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(appDelegate.threadParams)

    }



}
