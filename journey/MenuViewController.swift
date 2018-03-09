//
//  MenuViewController.swift
//  journey
//
//  Created by Spencer Edgecombe on 3/7/18.
//  Copyright © 2018 fwt. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var exitButton: UIButton!
    @IBOutlet var titleView: UIView!
    
    var myLocations : [Mark]!
    var viewController : ViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.4)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "LocationCellView", bundle: nil), forCellReuseIdentifier: "location_cell")
        tableView.rowHeight = 75
        titleView.layer.cornerRadius = 30
        titleView.layer.masksToBounds = true
        exitButton.layer.cornerRadius = 30
        exitButton.layer.masksToBounds = true
        // Do any additional setup after loading the view.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "location_cell") as! LocationCellView
        cell.render(withMark: myLocations[indexPath.row], andMenu: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mark = (tableView.cellForRow(at: indexPath) as! LocationCellView).mark
        self.dismiss(animated: true, completion: {
            self.viewController.focusOnLocation(latitude: (mark?.latitude)!, longitude: (mark?.longitude)!)
        })
    }
    
    @IBAction func exitTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
