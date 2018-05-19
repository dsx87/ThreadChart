//
//  UNViewController.swift
//  ThreadChart
//
//  Created by dsx on 29.12.17.
//  Copyright © 2017 Igor Pivnyk. All rights reserved.
//

import UIKit

class UNViewController: ThreadChartViewController {
    @IBOutlet weak var numberView: UNNumberInputView!
    @IBOutlet weak var fractionView: UNFractionInputView!
    @IBOutlet weak var decimalView: UNDecimalInputView!
    @IBOutlet weak var inputSwitch: UISegmentedControl!
    @IBOutlet weak var inOutSwitch: UISegmentedControl!
    
    var activeView:UIView?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        activeView = fractionView
        inputSwitch.addTarget(self, action: #selector(setUI), for: .valueChanged)
        inOutSwitch.addTarget(self, action: #selector(getParametersAndCalculate), for: .valueChanged)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = view.backgroundColor
    }
    
    @objc func setUI(){
        activeView?.resignFirstResponderFromSubviews()
        activeView?.unsetTextFieldsDelegate()
        switch inputSwitch.selectedSegmentIndex {
        case 0:
            decimalView.isHidden = true
            numberView.isHidden = true
            fractionView.isHidden = false
            activeView = fractionView
        case 1:
            decimalView.isHidden = false
            numberView.isHidden = true
            fractionView.isHidden = true
            activeView = decimalView
        case 2:
            decimalView.isHidden = true
            numberView.isHidden = false
            fractionView.isHidden = true
            activeView = numberView
        default:
            return
        }
        activeView?.setTextFieldsDelegate(to: self)
    }
    
    @objc func getParametersAndCalculate() {
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
        
        
        if let view = activeView as? UNDecimalInputView{
            diameter = view.diameter.text!.doubleValue
            pitch = view.TPI.text!.doubleValue
        }
        
        if let view = activeView as? UNNumberInputView {
            let base = 0.06
            let enteredNumber = view.number.text!.doubleValue
            if enteredNumber > 12 { return }
            diameter = base + (0.013 * enteredNumber)
            pitch = view.TPI.text!.doubleValue
        }
        
        if let view = activeView as? UNFractionInputView {
            let whole = view.wholePart.text!.doubleValue
            let num = view.nominator.text!.doubleValue
            let denom = view.denominator.text!.doubleValue
            diameter = Fraction(numerator: num, denominator: denom).decimalValue + whole
            pitch = view.TPI.text!.doubleValue
        }
        
        calculateThread()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        activeView?.resignFirstResponderFromSubviews()
        getParametersAndCalculate()
    }
}



