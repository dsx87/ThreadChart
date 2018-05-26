//
//  MenuViewController.swift
//  ThreadChart
//
//  Created by Igor Pivnyk on 18.05.2018.
//  Copyright © 2018 Igor Pivnyk. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {
    
    //Secondary view controllers
    let ISOvc = UIStoryboard(name: "NewInterface", bundle: nil).instantiateViewController(withIdentifier: "ISO")
    let UNvc = UIStoryboard(name: "NewInterface", bundle: nil).instantiateViewController(withIdentifier: "UN")
    let BSPPvc = UIStoryboard(name: "NewInterface", bundle: nil).instantiateViewController(withIdentifier: "BSPP")
    
    //threads description
    let threads = [["title":"ISO",
                    "description":"M/MF 60º"],
                   ["title":"UN",
                    "description":"C/F/S/EF 60º"],
                   ["title":"BSPP",
                    "description":"55º"]
                    ]
    
    
    var cellColors = [UIColor]() //array of colors for text in cells
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.white
        cellColors.append((ISOvc.view as! ViewControllerView).setISOView())
        cellColors.append((UNvc.view as! ViewControllerView).setUNView())
        cellColors.append((UNvc.view as! ViewControllerView).setBSPPView())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = view.backgroundColor
    }


    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return threads.count + 1
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let defaultRowHeight = tableView.rowHeight
        if indexPath.row == 0 {
            return 110
        }
        return defaultRowHeight
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "title", for: indexPath)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "threadName", for: indexPath)
        let threadDesc = threads[indexPath.row - 1]
        cell.textLabel?.text = threadDesc["title"]
        cell.textLabel?.textColor = cellColors[indexPath.row - 1]
        cell.detailTextLabel?.text = threadDesc["description"]

        return cell
    }
    
    //MARK: Table delegate methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let thread = threads[indexPath.row - 1]
        
        
        if thread["title"] == "ISO"{
            splitViewController?.showDetailViewController(ISOvc, sender: nil)
        }else if thread["title"] == "UN"{
            splitViewController?.showDetailViewController(UNvc, sender: nil)
        }else if thread["title"] == "BSPP"{
            splitViewController?.showDetailViewController(BSPPvc, sender: nil)
        }
    }


}
