//
//  PaperListTableViewController.swift
//  Abacus
//
//  Created by AyunaLabs on 29/11/21.
//

import UIKit

class PaperListTableViewController: UITableViewController {
    let papersName = ["Paper1","Paper2","Paper3","Paper4","Paper5","Paper6","Paper7"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        title = "Papers"
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        print(getTimeStampDateString())
        print("======== UserDefaults.standard ========")
        let myOwnUserDefault = UserDefaults(suiteName: "AbacusRecords")
        print( myOwnUserDefault?.dictionaryRepresentation())
        print("======== UserDefaults.standard ========")
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return papersName.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = "  \(papersName[indexPath.row])"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let navTitle = papersName[indexPath.row]
        if let model = getModelFor(at: indexPath) {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let practiceVC = storyBoard.instantiateViewController(identifier: "PracticeViewController") as! PracticeViewController
            practiceVC.title = navTitle
            practiceVC.abacusRootModel = model
            navigationController?.pushViewController(practiceVC, animated: true)
        } else {
            print("Fail to get expected model")
        }
    }
    
    func getModelFor(at index: IndexPath) -> AbacusRoot? {
        let navTitle = papersName[index.row].lowercased()
        guard let path = Bundle.main.path(forResource: "\(navTitle)", ofType: "json") else { return nil}
        
        let url = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: url)
            let abacusRootModel = try JSONDecoder().decode(AbacusRoot.self, from: data)
            //print(abacusRootModel)
            return abacusRootModel
        } catch {
            print(error)
        }
        return nil
    }
    
}
