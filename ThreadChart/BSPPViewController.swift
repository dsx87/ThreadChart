//
//  BSPPViewController.swift
//  ThreadChart
//
//  Created by Igor Pivnyk on 20.05.2018.
//  Copyright © 2018 Igor Pivnyk. All rights reserved.
//

import UIKit

class BSPPViewController: ThreadChartViewController {

    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var classSwitcher: UISegmentedControl!
    @IBOutlet weak var notApplicableLabel: UILabel!
    
    let threads = BSPPThreadsDatabase().threads
    var designation:Fraction?
    var isClassA:Bool!
    
    //MARK: Lifecicle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        classSwitcher.addTarget(self, action: #selector(getParametersAndCalculate), for: .valueChanged)
        designation = threads[picker.selectedRow(inComponent: 0)].designation
        getParametersAndCalculate()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = (view as! ViewControllerView).setBSPPView()
    }
    
    //MARK: Calculate Methods
    @objc override func getParametersAndCalculate(){
        isClassA = {
            if classSwitcher.selectedSegmentIndex == 0 { return true }
            return false
        }()
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
        setUI()
        guard let designation = designation else { clearLabels(); return }
        thread = BSPPThread(designation: designation, units: units, isInternal: isInternal, isClassA: isClassA)
        showCalculationResults()
    }
    
    //MARK: UI Methods
    func setUI() {
        if isInternal {
            classSwitcher.tintColor = UIColor.darkText
            classSwitcher.isEnabled = false
            notApplicableLabel.isHidden = false
        }else{
            classSwitcher.tintColor = UIColor.white
            classSwitcher.isEnabled = true
            notApplicableLabel.isHidden = true
        }
    }
    
}

//MARK: Picker delegate and datasource methods
extension BSPPViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return threads.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(threads[row].designation.stringValue) - \(threads[row].TPI)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.designation = threads[row].designation
        getParametersAndCalculate()
    }
    
    
}
