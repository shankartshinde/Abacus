//
//  ResultTableViewController.swift
//  Abacus
//
//  Created by AyunaLabs on 01/12/21.
//

import UIKit

class ResultTableViewController: UITableViewController {
    
    var resultList : [[String: String]] = [[:]]
    var sectionNames : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let myOwnUserDefault = UserDefaults(suiteName: "AbacusRecords")
//        print( myOwnUserDefault?.dictionaryRepresentation())
        myOwnUserDefault?.dictionaryRepresentation().forEach({ (arg0) in
            
            let (key, value) = arg0
            if let resultrecord = value as? [String: String], !resultrecord.isEmpty &&  key.hasPrefix("2021-")  {
                resultList.append(resultrecord)
            }
        })
        
        print(resultList)
        
        let papersName = getSections().compactMap { optionalString -> String? in
            guard let validStr = optionalString else { return nil }
            return String(validStr)
        }
        
        let uniqueNameOfPaper = Set(papersName)
        sectionNames = uniqueNameOfPaper.sorted()
        
        
//        print(getSections().compactMap { optionalString -> String? in
//            guard let validStr = optionalString else { return nil }
//            return String(validStr)
//        })
//
//        print(" Section Names : \(uniqueNameOfPaper.sorted())")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sectionNames.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return getTotalNumberOfRow(at: section)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames[section]
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ResultTableViewCell", for: indexPath) as? ResultTableViewCell {
            let resultRecord = getRecordForRow(at: indexPath)
            //["correctAnswers": "0", "totalTime": "00:08", "wrongAnswers": "2", "paperName": "Paper5", "date": "29.11.2021"]
            cell.dateLabel.text = "Date: \(resultRecord["date"] ?? "")"
            cell.correctAnswersLabel.text = "Correct: \(resultRecord["correctAnswers"] ?? "")"
            //cell.totalTimeLabel.text = "Time: \(resultRecord["totalTime"] ?? "")"
            cell.totalTimeLabel.text = "Time: \(resultRecord["currentDeviceTime"] ?? "")"
            
            let correctAnswer = Int(resultRecord["correctAnswers"] ?? "") ?? 0
            let wrongAnswer = Int(resultRecord["wrongAnswers"] ?? "") ?? 0
            let totalAttemptedAnswer = correctAnswer + wrongAnswer
            cell.totalAttemptSum.text = "Attempts : \(totalAttemptedAnswer.description)"
 
            return cell
        }

        return UITableViewCell()
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getSections() -> [String?] {
        return resultList.map { ($0["paperName"]) }
    }
    
//    func getRecord(at indexPath: IndexPath) -> [String: String] {
//        let sectionTitle = sectionNames[indexPath.section]
//
//        let allRecordsForSections = resultList.filter { $0["paperName"] == sectionTitle }
//        print("allRecordsForSections :: \(allRecordsForSections)")
//
//        return allRecordsForSections[indexPath.row]
//    }

    func getTotalNumberOfRow(at section: Int) -> Int {
        let sectionTitle = sectionNames[section]
        
        let allRecordsForSections = resultList.filter { $0["paperName"] == sectionTitle }
        return allRecordsForSections.count
    }

    func getRecordForRow(at indexPath: IndexPath) -> [String : String] {
        let sectionTitle = sectionNames[indexPath.section]

        let allRecordsForSections = resultList.filter { $0["paperName"] == sectionTitle }
//        print("allRecordsForSections :: \(allRecordsForSections)")
        return allRecordsForSections[indexPath.row]
    }

}
