//
//  ThreadChartViewController.swift
//  ThreadChart
//
//  Created by dsx on 01.01.18.
//  Copyright © 2018 Igor Pivnyk. All rights reserved.
//

import UIKit

class ThreadChartViewController: UIViewController {
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var majorDiameterLabel: UILabel!
    @IBOutlet weak var pitchDiameterLabel: UILabel!
    @IBOutlet weak var minorDiameterLabel: UILabel!
    @IBOutlet weak var tapHoleLabel: UILabel!
    
    @IBOutlet weak var diameterTextField: UITextField!
    @IBOutlet weak var pitchTextField: UITextField!
    
    @IBOutlet weak var inOutControl: UISegmentedControl!
    
    var standard:Thread.ThreadStandard!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        diameterTextField.delegate = self
        pitchTextField.delegate = self
        inOutControl.addTarget(self, action: #selector(calculateThread), for: .valueChanged)
        clearLabels()
        
        revealViewControllerHandler()
        subscribeToNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromNotifications()
    }
    
    //MARK: Reveal VC methods
    func revealViewControllerHandler(){
        if revealViewController() != nil{
            menuButton.addTarget(revealViewController(),
                                 action: #selector(SWRevealViewController.revealToggle(_:)),
                                 for: .touchUpInside)
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }else{
            print("Problem With revealVC in ISOViewController")
        }
    }
    
    
    
    //MARK: View Resizing
    
    func subscribeToNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(resizeMainView(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resizeMainView(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let size = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue
        return size.cgRectValue.height
    }
    
    func resizeMainView(_ notification:Notification){
        let keyboardHeight = getKeyboardHeight(notification)
        if notification.name == .UIKeyboardWillShow{
            view.frame.origin.y = 0 - keyboardHeight
            moveThreadParameters(by: keyboardHeight, isKeyboardHiding: false)
        }else if notification.name == .UIKeyboardWillHide {
            view.frame.origin.y = 0
            moveThreadParameters(by: keyboardHeight, isKeyboardHiding: true)
        }
    }
    
    func moveThreadParameters(by amount:CGFloat, isKeyboardHiding:Bool) {
        if isKeyboardHiding{
            self.topConstraint.constant -= amount
        }else {
            self.topConstraint.constant += amount
        }
    }
    //MARK: Hiding Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        pitchTextField.resignFirstResponder()
        diameterTextField.resignFirstResponder()
    }
    
    
    
    // MARK: Thread calculation method
    func calculateThread() {
        
        guard diameterTextField.text != nil, diameterTextField.text != "",          //Making Sure that text is enetered in text fields
            pitchTextField.text != nil, pitchTextField.text != "" else {return}     //
        
        
        // setting up numberFormatter
        let numberFormatter:NumberFormatter = {
            let nf = NumberFormatter()
            nf.numberStyle = .decimal
            nf.maximumFractionDigits = 3
            nf.minimumFractionDigits = 3
            nf.decimalSeparator = ","//Locale.current.decimalSeparator
            return nf
        }()
        
        //finding out what on segmented control
        let isInternal:Bool = {
            switch inOutControl.selectedSegmentIndex{
            case 0:
                return true
            case 1:
                return false
            default:
                return false
            }
        }()
        
        //Extracting diameter and pitch from textFields
        guard let diameter = numberFormatter.number(from: diameterTextField.text!) as? Double else {return}
        guard let pitch = numberFormatter.number(from: pitchTextField.text!) as? Double else {return}
        
        //calculating thread
        var threadParams:[Thread.ThreadParametersName:Any] = [
            Thread.ThreadParametersName.diameter: diameter,
            Thread.ThreadParametersName.pitch: pitch,
            Thread.ThreadParametersName.isInternal: isInternal,
            Thread.ThreadParametersName.standard: standard
        ]
        
        if standard == .iso{
            threadParams[Thread.ThreadParametersName.toleranceLevelBolt] = Thread.Tolerances.ISO.Bolt.g   // tolerances are hardcoded for now
            threadParams[Thread.ThreadParametersName.toleranceLevelNut] = Thread.Tolerances.ISO.Nut.H      //
        }else if standard == .un{
            threadParams[Thread.ThreadParametersName.toleranceLevelBolt] = Thread.Tolerances.UN.Bolt.twoA   // tolerances are hardcoded for now
            threadParams[Thread.ThreadParametersName.toleranceLevelNut] = Thread.Tolerances.UN.Nut.twoB      //
            
        }
        
        let thread = Thread(threadParameters: threadParams)
        
        //converting all parameters to string
        let maxMajorString = numberFormatter.string(from: thread.maxMajorDiameter as NSNumber)!
        let minMajorString = numberFormatter.string(from: thread.minMajorDiameter as NSNumber)!
        let maxPitchString = numberFormatter.string(from: thread.maxPitchDiameter as NSNumber)!
        let minPitchString = numberFormatter.string(from: thread.minPitchDiameter as NSNumber)!
        let maxMinorString = numberFormatter.string(from: thread.maxMinorDiameter as NSNumber)!
        let minMinorString = numberFormatter.string(from: thread.minMinorDiameter as NSNumber)!
        
        if let tap = thread.tapHole {
            guard let tapString = numberFormatter.string(from: tap as NSNumber) else {tapHoleLabel.text = ""; return}
            tapHoleLabel.text = "Tap Hole: \(tapString)"
        }else{
            tapHoleLabel.text = ""
        }
        
        
        majorDiameterLabel.text = "\(maxMajorString) \r \(minMajorString)"
        pitchDiameterLabel.text = "\(maxPitchString) \r \(minPitchString)"
        minorDiameterLabel.text = "\(maxMinorString) \r \(minMinorString)"
    }
    
    //MARK: Helper methods
    func clearLabels(){
        tapHoleLabel.text = ""
        majorDiameterLabel.text = ""
        minorDiameterLabel.text = ""
        pitchDiameterLabel.text = ""
    }
}



// MARK: TextFieldDelegate Methods
extension ThreadChartViewController:UITextFieldDelegate {
    
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
        
        if string == numberFiltered {
            if string == ""{
                if textField.text?.characters.count == 1 {
                    clearLabels()
                    return true
                }
                let index = textField.text?.index(before: (textField.text?.endIndex)!)
                textField.text?.remove(at: index!)
                calculateThread()
                return false
            }
            textField.text?.append(string)
            calculateThread()
        }
        
        return false
        
        
    }
    
}
