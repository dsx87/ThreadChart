//
//  HelpViewController.swift
//  ThreadChart
//
//  Created by Igor Pivnyk on 28.04.2018.
//  Copyright © 2018 Igor Pivnyk. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
    
    @IBOutlet weak var label:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.layer.cornerRadius = 10.0
        label.layer.backgroundColor = UIColor.brown.cgColor

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }

}
