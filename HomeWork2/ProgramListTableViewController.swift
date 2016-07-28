//
//  ProgramListTableViewController.swift
//  HomeWork2
//
//  Created by student on 7/22/16.
//  Copyright © 2016 Pawan Araballi. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON
import Alamofire

class ProgramListTableViewController: UITableViewController {
    
    //var programsData : [ProgramsList]?
    var programsData : JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accessPrograms()
    }
    
    func accessPrograms() {
        Alamofire.request(.GET, "http://api.npr.org/list?id=3004&output=json").validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    self.loadPrograms(json)
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
    
  
    func loadPrograms(json : JSON ) {
        self.programsData = json["item"]
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if programsData == nil {
            return 0
        }else {
            return self.programsData!.count
        }
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("programsCell", forIndexPath: indexPath)
        cell.textLabel!.text = String(programsData![indexPath.row]["title"]["$text"])
        cell.detailTextLabel?.text = String(programsData![indexPath.row]["additionalInfo"]["$text"])

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "programSegue" {
        //print(String(programsData![tableView.indexPathForSelectedRow!.row]["id"]))
            if let destination = segue.destinationViewController as? StoryTableViewController {
                //print("true")
                destination.programId = String(programsData![tableView.indexPathForSelectedRow!.row]["id"])
            }
        }
    }
 

}
