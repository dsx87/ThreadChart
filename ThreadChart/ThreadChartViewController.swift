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
    @IBOutlet weak var helpButton: UIButton!
    
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
        setUI()
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
            revealViewController().rearViewRevealWidth = 200
            revealViewController().rearViewRevealOverdraw = 0
            menuButton.addTarget(revealViewController(),
                                 action: #selector(SWRevealViewController.revealToggle(_:)),
                                 for: .touchUpInside)
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }else{
            print("Problem With revealVC in ISOViewController")
        }
    }
    
    
    
    //MARK: View Resizing On keyboad show
    
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
            menuButton.removeTarget(revealViewController(),
                                    action: #selector(SWRevealViewController.revealToggle(_:)),
                                    for: .touchUpInside)
            view.frame.origin.y = 0 - keyboardHeight
            moveThreadParametersLabels(by: keyboardHeight, isKeyboardHiding: false)
        }else if notification.name == .UIKeyboardWillHide {
            menuButton.addTarget(revealViewController(),
                                 action: #selector(SWRevealViewController.revealToggle(_:)),
                                 for: .touchUpInside)
            view.frame.origin.y = 0
            moveThreadParametersLabels(by: keyboardHeight, isKeyboardHiding: true)
        }
    }
    
    func moveThreadParametersLabels(by amount:CGFloat, isKeyboardHiding:Bool) {
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
    
    
    
    // MARK: Thread calculation methods
    
    func getValuesFromTextFields() -> (Double?,Double?){
        
        var result:(Double?,Double?) = (nil,nil)
        
        //Checking if fields is not empty
        guard let diamText = diameterTextField.text, diameterTextField.text != "",
            let pitchText = pitchTextField.text, pitchTextField.text != "" else  { return result }
        
        //Help Function to work with fractions
        func calculateFraction(_ string:String) -> Double? {
            var numbers:[Double] = []
            let tempArray = string.components(separatedBy: "/")
            if tempArray.count != 2 {return nil}
            if tempArray[1] == "" || tempArray[0] == "" {return nil}
            tempArray.forEach{elem in
                if let num = Double(elem){
                    numbers.append(num)
                }else{
                    return
                }
            }
            return numbers[0] / numbers[1]
        }
        //------------------------------------
        
        
        if diamText.contains(" "){ //whole and fraction input
            let fractionAndWholeNumberSeparated = diamText.components(separatedBy: " ")
            if fractionAndWholeNumberSeparated.count > 2 { return result }
            
            guard let wholeNum = Double(fractionAndWholeNumberSeparated[0]) else { return result }
            guard let fractionNum = calculateFraction(fractionAndWholeNumberSeparated[1]) else { return result }
            
            result.0 = wholeNum + fractionNum
            
        }else if diamText.contains("/") {  //fraction input
            result.0 = calculateFraction(diamText)
            
            
        }else if diamText.contains("#"){  //number input
            let zero = 0.06
            let diamTextWithoutSign = diamText.trimmingCharacters(in: CharacterSet.decimalDigits.inverted)
            guard let actualNumber = Double(diamTextWithoutSign) else {return result}
            if actualNumber > 12 { return result }
            result.0 = zero + (0.013 * actualNumber)
        }else{
            result.0 = Double(diamText)
        }
        
        result.1 = Double(pitchText)
        
        return result
    }
    
    func calculateThread() {
        
        // setting up numberFormatter
        let numberFormatter:NumberFormatter = {
            let nf = NumberFormatter()
            nf.numberStyle = .decimal
            if standard == .iso{
                nf.maximumFractionDigits = 3
                nf.minimumFractionDigits = 3
            }else if standard == .un{
                nf.maximumFractionDigits = 4
                nf.minimumFractionDigits = 4
            }
            nf.decimalSeparator = Locale.current.decimalSeparator
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
        
        
        guard let diameter = getValuesFromTextFields().0 else {return}
        guard let pitch = getValuesFromTextFields().1 else {return}
        
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
        pitchDiameterLabel.text = " \r \r Enter thread diameter and pitch (TPI)"
    }
    
    func setUI(){
        helpButton.layer.bounds.size = CGSize(width: 25.0, height: 25.0)
        helpButton.layer.borderWidth = 1
        helpButton.layer.borderColor = UIColor.white.cgColor
        helpButton.layer.cornerRadius = helpButton.layer.bounds.size.height / 2
        
    }
    
    //MARK: Alert View
    func showAlert(text:String){
        let alertVC = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertVC.addAction(okButton)
        present(alertVC, animated: true, completion: nil)
    }
    
    //MARK: Popover view
    @IBAction func helpButtonTap(sender: UIButton){
        let popController = UIStoryboard(name: "NewInterface", bundle: nil).instantiateViewController(withIdentifier: "popover")
        
        popController.modalPresentationStyle = .popover
        popController.popoverPresentationController?.permittedArrowDirections = .up
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = sender
        popController.popoverPresentationController?.sourceRect = sender.bounds
        
        let label = popController.view as! UILabel
        if standard == .iso {
            label.text = "Enter Thread Nominal Diameter and Pitch"
        }else if standard == .un{
            label.text = "Enter Thread Nominal Diameter (Fraction or Decimal) anr TPI \r" +
            "For number diameter use '#' sign (e.g. #10)"
        }
        
        self.present(popController, animated: true, completion: nil)
        
        
        
    }
    
    
    
}



// MARK: TextFieldDelegate Methods
extension ThreadChartViewController:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
            
            
            if textField.tag == 1 { //working with diameter field
                
                //checking if text already contains decimal separator, division sign or number sign
                let singleCharacterAllowedSet = CharacterSet(charactersIn: "./#")
                let countDots = (textField.text!.components(separatedBy: singleCharacterAllowedSet).count) - 1
                
                //checking if new character is a number, decimal separator or division sign or number sign
                let allowedCharactersSet = CharacterSet(charactersIn: "0123456789./# ").inverted
                let compSepByCharInSet = string.components(separatedBy: allowedCharactersSet)
                let numberFiltered = compSepByCharInSet.joined(separator: "")
                
                //performing checkings for dots count and field beggining
                if (countDots > 0 || textField.text == ""), (string == "." || string == "/" || string == " ") {
                    return false
                }
                
                //number sign need to be in the begging
                if textField.text == "", string == "#"{
                    return true
                }
                
                if string == numberFiltered { // if inserting character is allowed then continue
                    if string == ""{                                    //if backspace pressed
                        if textField.text?.characters.count == 1 {      //and it will remove last symbol in a field
                            clearLabels()                               //then clearing labels
                            return true
                        }
                        let index = textField.text?.index(before: (textField.text?.endIndex)!)  //index of last character in string
                        textField.text?.remove(at: index!)                                      //removing it and updating calculations
                        calculateThread()
                        return false
                    }
                    textField.text?.append(string)
                    calculateThread()
                }
                
            }
        
        
        
        if textField.tag == 2{ // working with pitch field
            
            //checking if text already contains decimal separator
            let dotSet = CharacterSet(charactersIn: ".")
            let countDots = (textField.text!.components(separatedBy: dotSet).count) - 1
            
            //checking if new character is a number
            let set = CharacterSet(charactersIn: "0123456789.").inverted
            let compSepByCharInSet = string.components(separatedBy: set)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            
            // performing checkings for dot count
            if (countDots > 0), string == "." {
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
            
        }
        
        return false
        
        
    }
    
}

//MARK: popoverPresentationController Delegate methods
extension ThreadChartViewController: UIPopoverPresentationControllerDelegate{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
