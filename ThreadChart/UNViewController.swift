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
    
    var activeView:UIView?
    var diameter:Double?
    var pitch:Double?
    
    //MARK: Lifecicle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        activeView = fractionView
        inputSwitch.addTarget(self, action: #selector(setUI), for: .valueChanged)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = (view as! ViewControllerView).setUNView()
    }
    
    //MARK: UI Methods
    @objc func setUI(){
        clearLabels()
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
    
    //MARK: Calculation methods
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
        
        
        if let view = activeView as? UNDecimalInputView{
            guard let diameter = view.diameter.text?.doubleValue,
                let pitch = view.TPI.text!.doubleValue else { clearLabels(); return }
            self.diameter = diameter
            self.pitch = pitch
        }
        
        if let view = activeView as? UNNumberInputView {
            guard let enteredNumber = view.number.text?.doubleValue else { clearLabels(); return }
            let base = 0.06
            if enteredNumber > 12.0 { return }
            diameter = base + (0.013 * enteredNumber)
            pitch = view.TPI.text!.doubleValue
        }
        
        if let view = activeView as? UNFractionInputView {
            var wholeValue:Double!
            if let whole = view.wholePart.text?.doubleValue{
                wholeValue = whole
            }else{
                wholeValue = 0
            }
            guard let num = view.nominator.text?.doubleValue,
                let denom = view.denominator.text?.doubleValue,
                let pitch = view.TPI.text?.doubleValue,
                let diameter = Fraction(numerator: Int(num), denominator: Int(denom), wholeValue: Int(wholeValue))?.decimalValue
                else { clearLabels(); return }
            
            self.diameter = diameter
            self.pitch = pitch
        }
        
        guard let diameter = self.diameter else { clearLabels(); return }
        guard let pitch = self.pitch else { clearLabels(); return }
        
        thread = UNThread(diameter: diameter, TPI: pitch, isInternal: isInternal, tolerance: .two, units: units)
        showCalculationResults()
        self.diameter = nil
        self.pitch = nil
    }
    
    //resigning first responder
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        activeView?.resignFirstResponderFromSubviews()
        getParametersAndCalculate()
    }
}



