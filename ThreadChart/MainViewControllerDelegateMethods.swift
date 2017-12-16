//
//  MainViewControllerDelegateMethods.swift
//  ThreadChart
//
//  Created by Igor Pivnyk on 28.11.2017.
//  Copyright © 2017 Igor Pivnyk. All rights reserved.
//

import UIKit


extension MainViewController {
    
    //MARK: Picker Data Source Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Thread.ThreadStandard.count
    }
    
    //MARK: Picker Delegate Methods
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return pickerView.bounds.size.height
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        
        return pickerView.bounds.size.width
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = Thread.threadTypes[row]
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch Thread.threadTypes[row] {
        case "Metric Threads (ISO)":
            threadPrefixLabel.text = "M"
            threadTypeSeparator.text = "x"
            threadDiameterTextField.placeholder = "10"
            threadPitchTextField.placeholder = "20"
            
        case "United Threads (UN)":
            threadPrefixLabel.text = ""
            threadTypeSeparator.text = "-"
            threadDiameterTextField.placeholder = "1/2"
            threadPitchTextField.placeholder = "16"
        default:
            return
        }
    }
    
    //MARK: tableView dataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentThread.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = "test text"
        cell.detailTextLabel?.text = "test detail text"
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Recent Threads"
    }
    
    //MARK: Navigation Controller Delegate
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let vc = viewController as? MainViewController{
            vc.tableView.reloadData()
        }
    }
    
}
