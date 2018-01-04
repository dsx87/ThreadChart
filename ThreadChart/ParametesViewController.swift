//
//  ExternalViewController.swift
//  ThreadChart
//
//  Created by dsx on 19.12.17.
//  Copyright © 2017 Igor Pivnyk. All rights reserved.
//

import UIKit

class ParametersViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate // setting access to appDelegate
    
    //MARK: Outlets
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var diameterTextField: UITextField!
    @IBOutlet weak var pitchTextField: UITextField!
    
    //MARK:Properties
    var nutTolerances:[String] = []
    var boltTolerances:[String] = []
    var currentStandard:Thread.ThreadStandard!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
        pitchTextField.delegate = self
        diameterTextField.delegate = self
        
        
        
        currentStandard = appDelegate.threadParams[.standard] as! Thread.ThreadStandard
        switch currentStandard! {
        case .iso:
            nutTolerances = Thread.isoNutTolerances
            boltTolerances = Thread.isoBoltTolreances
            
            appDelegate.threadParams[.toleranceLevelBolt] = Thread.Tolerances.ISO.Bolt.g
            appDelegate.threadParams[.toleranceLevelNut] = Thread.Tolerances.ISO.Nut.H
            
        case .un:
            boltTolerances = Thread.unBoltTolerances
            nutTolerances = Thread.unNutTolerances
            
            appDelegate.threadParams[.toleranceLevelBolt] = Thread.Tolerances.UN.Bolt.twoA
            appDelegate.threadParams[.toleranceLevelNut] = Thread.Tolerances.UN.Nut.twoB
            
        }
        
        
        setUI(for: currentStandard)
    }

    // MARK:Actions
    @IBAction func calculate(_ sender: UIButton) {
        let nf = NumberFormatter()
        nf.locale = Locale(identifier: Locale.current.identifier)
        nf.numberStyle = .decimal
        nf.decimalSeparator = ","
        
        if diameterTextField.text == nil || diameterTextField.text == "" ||
            pitchTextField.text == nil   || pitchTextField.text == "" {
    
            showAlert(text: "Diameter and/or pitch field is empty")
            return
        }
        
        
        guard let diam = nf.number(from: diameterTextField.text!) else {
            print("problem with diameter value")
            return
        }
        guard let pitch = nf.number(from: pitchTextField.text!) else {
            print("priblem with pitch value")
            return
        }
        

        appDelegate.threadParams[.diameter] = diam
        appDelegate.threadParams[.pitch] = pitch
        
        performSegue(withIdentifier: "resultsSegue", sender: nil)
    }
   
    
    // MARK: Help methods
    func showAlert(text:String){
        let vc = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        vc.addAction(alertAction)
        self.present(vc, animated: true, completion: nil)
    }
    
    
    func hideKeyboard(){
        diameterTextField.resignFirstResponder()
        pitchTextField.resignFirstResponder()
    }
    
    func setUI(for standard:Thread.ThreadStandard){
        calculateButton.layer.borderWidth = 0.5
        calculateButton.layer.borderColor = UIColor.darkGray.cgColor
        picker.showsSelectionIndicator = true
        
        switch standard {
        case .iso:
            picker.selectRow(boltTolerances.index(of: "g")!, inComponent: 0, animated: false)
            picker.selectRow(nutTolerances.index(of: "H")!, inComponent: 1, animated: false)
        case .un:
            picker.selectRow(boltTolerances.index(of: "2A")!, inComponent: 0, animated: false)
            picker.selectRow(nutTolerances.index(of: "2B")!, inComponent: 1, animated: false)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    
    
    
    
    
    
    
    
    
    // MARK:PickerView DataSource methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2 // first for bolts, second for nuts
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? boltTolerances.count : nutTolerances.count
    }
    
    
    
    
    
    
    // MARK:PickerView Delegate Methods
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return component == 0 ? boltTolerances[row] : nutTolerances[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //setting picker to most common combination of tolerances
        switch currentStandard! {
        case .iso:
            if component == 0 {
                appDelegate.threadParams[.toleranceLevelBolt] = Thread.Tolerances.ISO.Bolt(rawValue: row)
            } else {
                appDelegate.threadParams[.toleranceLevelNut] = Thread.Tolerances.ISO.Nut(rawValue:row)
            }
        case .un:
            if component == 0 {
                appDelegate.threadParams[.toleranceLevelBolt] = Thread.Tolerances.UN.Bolt(rawValue: row)
            }else{
                appDelegate.threadParams[.toleranceLevelNut] = Thread.Tolerances.UN.Nut(rawValue: row)
            }
        }
    }
    
    
    
    //MARK: TextField Delegate Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //checking if text already contains decimal separator
        let dotSet = CharacterSet(charactersIn: ".,")
        let countDots = (textField.text!.components(separatedBy: dotSet).count) - 1
        
        //checking if new character is a number
        let set = CharacterSet(charactersIn: "0123456789,.").inverted
        let compSepByCharInSet = string.components(separatedBy: set)
        print(compSepByCharInSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        
        //actually performing checkings
        if countDots > 0, (string == "," || string == ".") {
            return false
        }
        
        return string == numberFiltered
        
        
    }

}
