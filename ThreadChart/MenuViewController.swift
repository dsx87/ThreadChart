//
//  MenuViewController.swift
//  ThreadChart
//
//  Created by Igor Pivnyk on 18.05.2018.
//  Copyright © 2018 Igor Pivnyk. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {

    
    let threads = [["title":"ISO",
                         "description":"M/MF 60º"],
                        ["title":"UN",
                         "description":"C/F/S/EF 60º"]
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.white
        
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
            return 80
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
        cell.detailTextLabel?.text = threadDesc["description"]

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let thread = threads[indexPath.row - 1]
        let ISOvc = UIStoryboard(name: "NewInterface", bundle: nil).instantiateViewController(withIdentifier: "ISO")
        let UNvc = UIStoryboard(name: "NewInterface", bundle: nil).instantiateViewController(withIdentifier: "UN")
        
        if thread["title"] == "ISO"{
            splitViewController?.showDetailViewController(ISOvc, sender: nil)
        }else{
            splitViewController?.showDetailViewController(UNvc, sender: nil)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
