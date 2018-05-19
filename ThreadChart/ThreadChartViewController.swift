//
//  ThreadChartViewController.swift
//  ThreadChart
//
//  Created by dsx on 01.01.18.
//  Copyright © 2018 Igor Pivnyk. All rights reserved.
//

import UIKit

class ThreadChartViewController: UIViewController {
    
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var majorDiameterLabel: UILabel!
    @IBOutlet weak var pitchDiameterLabel: UILabel!
    @IBOutlet weak var minorDiameterLabel: UILabel!
    @IBOutlet weak var tapHoleLabel: UILabel!
    @IBOutlet weak var mmInchSwitch: UISegmentedControl!
    
    var thread:ThreadProtocol!
    var diameter:Double?
    var pitch:Double?
    var isInternal:Bool!
    var units:Units!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearLabels()
        setUnitsValue()
        mmInchSwitch.addTarget(self, action: #selector(setUnitsValue), for: .valueChanged)
    }
    
    @objc func setUnitsValue() {
        if mmInchSwitch.selectedSegmentIndex == 0 { units = .mm }
        if mmInchSwitch.selectedSegmentIndex == 1 { units = .inch }
        getParametersAndCalculate()
    }
    
    @objc func getParametersAndCalculate(){}
    
    func calculateThread(){
        guard let diameter = self.diameter else { clearLabels(); return }
        guard let pitch = self.pitch else { clearLabels(); return }
        
        if self is ISOViewController {
            thread = ISOThread(diameter: diameter, pitch: pitch, isInternal: isInternal, inTolerance: .h, outTolerance: .g, units: units)
        } else if self is UNViewController {
            thread = UNThread(diameter: diameter, TPI: pitch, isInternal: isInternal, tolerance: .two, units: units)
        }

        let numberFormatter:NumberFormatter = thread.numberFormatter
        
        
            
        //converting all parameters to string
        let maxMajorString = numberFormatter.string(from: thread.maxMajorDiameter as NSNumber)!
        let minMajorString = numberFormatter.string(from: thread.minMajorDiameter as NSNumber)!
        let maxPitchString = numberFormatter.string(from: thread.maxPitchDiameter as NSNumber)!
        let minPitchString = numberFormatter.string(from: thread.minPitchDiameter as NSNumber)!
        let maxMinorString = numberFormatter.string(from: thread.maxMinorDiameter as NSNumber)!
        let minMinorString = numberFormatter.string(from: thread.minMinorDiameter as NSNumber)!
        
        if let tap = thread.taphole {
            guard let tapString = numberFormatter.string(from: tap as NSNumber) else {tapHoleLabel.text = ""; return}
            tapHoleLabel.text = "Tap Hole: \(tapString)"
        }else{
            tapHoleLabel.text = ""
        }
        
        
        majorDiameterLabel.text = "\(maxMajorString) \r \(minMajorString)"
        pitchDiameterLabel.text = "\(maxPitchString) \r \(minPitchString)"
        minorDiameterLabel.text = "\(maxMinorString) \r \(minMinorString)"
        
        self.diameter = nil
        self.pitch = nil
    }
    
    // MARK: Thread calculation methods
    
    

    //MARK: Helper methods
    func clearLabels(){
        tapHoleLabel.text = ""
        majorDiameterLabel.text = ""
        minorDiameterLabel.text = ""
        pitchDiameterLabel.text = " \r \r Enter thread diameter and pitch (TPI)"
    }
    
}



// MARK: TextFieldDelegate Methods
extension ThreadChartViewController:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        //checking if text already contains decimal separator
        let dotSet = CharacterSet(charactersIn: ".")
        let countDots = (textField.text!.components(separatedBy: dotSet).count) - 1
        
        let commaSet = CharacterSet(charactersIn: ",")
        let countCommas = (textField.text!.components(separatedBy: commaSet).count) - 1

        //checking if new character is a number
        let set = CharacterSet(charactersIn: "0123456789,.").inverted
        let compSepByCharInSet = string.components(separatedBy: set)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        
        // performing checkings for dot count
        if (countDots > 0) || (countCommas > 0) , string == "." || string == "," {
            return false
        }
        
        if string == numberFiltered {
            if string == ""{
                if textField.text?.count == 1 {
                    return true
                }
                let index = textField.text?.index(before: (textField.text?.endIndex)!)
                textField.text?.remove(at: index!)
                return false
            }
            textField.text?.append(string)
        }
        return false
        
        
    }
    
}
