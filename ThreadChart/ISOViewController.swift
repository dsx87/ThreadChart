//
//  ISOViewController.swift
//  ThreadChart
//
//  Created by dsx on 01.01.18.
//  Copyright © 2018 Igor Pivnyk. All rights reserved.
//

import UIKit

class ISOViewController: ThreadChartViewController {
    @IBOutlet weak var diameterTextField: UITextField!
    @IBOutlet weak var pitchTextField: UITextField!
    @IBOutlet weak var inOutSwitch: UISegmentedControl!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inOutSwitch.addTarget(self, action: #selector(getParametersAndCalculate), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = view.backgroundColor
    }
    
    
    @objc override func getParametersAndCalculate() {
        isInternal = {
            switch inOutSwitch.selectedSegmentIndex{
            case 0:
                return true
            case 1:
                return false
            default:
                return false
            }
        }()
        if let diameter = diameterTextField.text?.doubleValue,
            let pitch = pitchTextField.text?.doubleValue{
                self.diameter = diameter
                self.pitch = pitch
        } else { clearLabels() }
        
        calculateThread()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        diameterTextField.resignFirstResponder()
        pitchTextField.resignFirstResponder()
        getParametersAndCalculate()
    }

}
