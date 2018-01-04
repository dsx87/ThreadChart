//
//  InternalThreadViewController.swift
//  ThreadChart
//
//  Created by dsx on 19.12.17.
//  Copyright © 2017 Igor Pivnyk. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var maxSizeLabels: [UILabel]!
    @IBOutlet var minSizeLabels: [UILabel]!
    @IBOutlet weak var tapHoleLabel: UILabel!
    @IBOutlet weak var newThreadButton: UIButton!
    @IBOutlet weak var mmInchSwitcher: UISegmentedControl!
    
    private var thread:Thread!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newThreadButton.layer.borderColor = UIColor.lightGray.cgColor
        newThreadButton.layer.borderWidth = 1.0
        
        thread = Thread(threadParameters: appDelegate.threadParams)
        setAllLabels()
        
   
    }

    @IBAction func newThreadAction(_ sender: UIButton) {
       let _ = navigationController?.popToRootViewController(animated: true)
    }
    
    func setAllLabels(){
        let nf = NumberFormatter()
        nf.maximumFractionDigits = 3
        
        for (i, label) in maxSizeLabels.enumerated(){
            switch i {
            case 0:
                label.text = nf.string(from: thread.maxMajorDiameter as NSNumber)
            case 1:
                label.text = nf.string(from: thread.maxPitchDiameter as NSNumber)
            case 2:
                label.text = nf.string(from: thread.maxMinorDiameter as NSNumber)
            default:
                break
            }
        }
        
        for (i, label) in minSizeLabels.enumerated(){
            switch i {
            case 0:
                label.text = nf.string(from: thread.minMajorDiameter as NSNumber)
            case 1:
                label.text = nf.string(from: thread.minPitchDiameter as NSNumber)
            case 2:
                label.text = nf.string(from: thread.minMinorDiameter as NSNumber)
            default:
                break
            }
        }
        
        if let tapHole = thread.tapHole{
            tapHoleLabel.text = nf.string(from: tapHole as NSNumber)
        }else{
            tapHoleLabel.text = "Not applicable"
        }
        
    }

}
