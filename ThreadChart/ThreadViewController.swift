//
//  ThreadViewController.swift
//  ThreadChart
//
//  Created by Igor Pivnyk on 28.11.2017.
//  Copyright © 2017 Igor Pivnyk. All rights reserved.
//

import UIKit

class ThreadViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tapHoleLabel: UILabel!
    @IBOutlet weak var tapHoleValueLabel: UILabel!
    
    @IBOutlet weak var table: UITableView!
    
    var thread:Thread!
    var threadParams = [(String,String,String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.rowHeight = 65
        
        if let tapHole = thread.tapHole {
            tapHoleValueLabel.text = "\(tapHole)"
        }else{
            tapHoleLabel.isHidden = true
            tapHoleValueLabel.isHidden = true
        }
        
        let nf:NumberFormatter = {
            let nf = NumberFormatter()
            nf.maximumFractionDigits = 3
            return nf
        }()
        
        func tupleFromValue(valueName:String, valueMAX:Double, valueMIN:Double) -> (String,String,String){
            let valueMAXString = nf.string(from: NSNumber(value: valueMAX))!
            let valueMINString = nf.string(from: NSNumber(value: valueMIN))!
            return (valueName,"Max: \(valueMAXString)","Min: \(valueMINString)")
        }
 
        
        
        threadParams.append(tupleFromValue(valueName: "Major Diameter",
                                           valueMAX: thread.maxMajorDiameter,
                                           valueMIN: thread.minMajorDiameter))
        threadParams.append(tupleFromValue(valueName: "Minor Diameter",
                                           valueMAX: thread.maxMinorDiameter,
                                           valueMIN: thread.minMinorDiameter))
        threadParams.append(tupleFromValue(valueName: "Pitch Diameter",
                                           valueMAX: thread.maxPitchDiameter,
                                           valueMIN: thread.minPitchDiameter))
        }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return threadParams.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "threadCell") as! ThreadTableViewCell
        
        cell.threadNameLabel.text = threadParams[indexPath.row].0
        cell.maxLabel.text = threadParams[indexPath.row].1
        cell.minLabel.text = threadParams[indexPath.row].2
        
        return cell
    }
    
    
 

}
