//
//  ViewController.swift
//  ThreadChart
//
//  Created by Igor Pivnyk on 27.11.2017.
//  Copyright © 2017 Igor Pivnyk. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource, UINavigationControllerDelegate {
    @IBOutlet weak var externalLabel: UILabel!
    @IBOutlet weak var inOutSwitch: UISwitch!
    @IBOutlet weak var internalLabel: UILabel!
    @IBOutlet weak var threadDiameterTextField: UITextField!
    @IBOutlet weak var threadTypeSeparator: UILabel!
    @IBOutlet weak var threadPrefixLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var threadPitchTextField: UITextField!
    var recentThread = [Thread]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
        tableView.dataSource = self
        self.navigationController?.delegate = self
        setInitialLook()
        
        inOutSwitch.addTarget(self, action: #selector(setLabelsBackground), for: .valueChanged)
        
    }
    
    @IBAction func showThread(_ sender: UIButton) {
        let threadStandard = Thread.ThreadStandard(rawValue: picker.selectedRow(inComponent: 0))!
        guard let diameterString = threadDiameterTextField.text, diameterString != "" else {
            showWarning(text: "Diameter not set")
            return
        }
        
        guard let pitchString = threadPitchTextField.text, pitchString != "" else {
            showWarning(text: "Pitch not set")
            return
        }
        let diam = Double(diameterString)!
        let pitch = Double(pitchString)!
        let isInternal = {return inOutSwitch.isOn ? true : false }()
        let threadParams:[Thread.ThreadParametersName:Any] = [
            .diameter:diam,
            .pitch:pitch,
            .isInternal:isInternal,
            .standard:threadStandard,
            .toleranceLevelNut: Thread.Tolerances.UN.Nut.twoB, //TEMPORARILY
            .toleranceLevelBolt: Thread.Tolerances.UN.Bolt.twoA //TEMPORARILY
            ]
        let thread = Thread(threadParameters: threadParams)
        recentThread.append(thread)
        let vc = storyboard?.instantiateViewController(withIdentifier: "ThreadVC") as! ThreadViewController
        vc.thread = thread
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func setLabelsBackground() {
        if inOutSwitch.isOn{
            UIView.animate(withDuration: 0.3){
                self.internalLabel.layer.backgroundColor = UIColor.lightGray.cgColor
                self.internalLabel.layer.borderWidth = 1
                
                self.externalLabel.layer.backgroundColor = UIColor.clear.cgColor
                self.externalLabel.layer.borderWidth = 0
                
            }
        }else{
            UIView.animate(withDuration: 0.3){
                self.internalLabel.layer.backgroundColor = UIColor.clear.cgColor
                self.internalLabel.layer.borderWidth = 0

                self.externalLabel.layer.backgroundColor = UIColor.lightGray.cgColor
                self.externalLabel.layer.borderWidth = 1
            }
        }
    }
    
    func setInitialLook() {
        
        internalLabel.backgroundColor = UIColor.clear
        internalLabel.layer.masksToBounds   = true
        internalLabel.layer.cornerRadius    = 10
        internalLabel.layer.borderWidth     = 0
        internalLabel.layer.borderColor     = UIColor.black.cgColor
        
        externalLabel.backgroundColor = UIColor.clear
        externalLabel.layer.masksToBounds   = true
        externalLabel.layer.cornerRadius    = 10
        externalLabel.layer.borderWidth     = 0
        externalLabel.layer.borderColor     = UIColor.black.cgColor
        setLabelsBackground()
        
        inOutSwitch.layer.masksToBounds     = true
        inOutSwitch.layer.cornerRadius      = 16
        inOutSwitch.layer.borderWidth       = 1.3
        inOutSwitch.layer.borderColor       = UIColor.darkGray.cgColor
    }
    
    func showWarning(text:String){
        let alertViewController = UIAlertController(title: text,
                                                    message: "",
                                                    preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertViewController.addAction(alertAction)
        self.present(alertViewController, animated: true, completion: nil)
        
    }
}



