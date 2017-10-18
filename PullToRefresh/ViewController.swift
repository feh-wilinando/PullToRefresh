//
//  ViewController.swift
//  PullToRefresh
//
//  Created by Nando on 10/10/17.
//  Copyright © 2017 Nando. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var datasource = [
        "Fernando","Willian","De","Souza","Furtado"
    ]
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
            
        
        let refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string:"Pull to Refresh")
        refresh.addTarget(self, action: #selector(refreshAction(sender:)), for: .valueChanged)
        
        tableView.addSubview(refresh)
        
    }
    
    
    @objc fileprivate func refreshAction(sender: UIRefreshControl?){
     
        for i in 1...10 {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                
                self.datasource.append("Outro \(i)")
                
                let indexPath = IndexPath(row: self.datasource.count-1, section: 0)
                
                self.tableView.insertRows(at: [indexPath], with: .fade)
            }
        }
        
        sender?.endRefreshing()
    }
    
}



extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let name = datasource[indexPath.row]
        
        cell.textLabel?.text = name
        
        return cell
    }
    
}

extension ViewController: UITableViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        guard scrollView is UITableView else { return }
        
        let axisYOfContent = scrollView.contentOffset.y
        let frameHeight = scrollView.frame.size.height
        let contentHeight = scrollView.contentSize.height
        
        
        if axisYOfContent + frameHeight >= contentHeight {
            refreshAction(sender: nil)
        }
        
    }
}
