//
//  PlayListTableViewController.swift
//  HomeWork2
//
//  Created by student on 7/23/16.
//  Copyright © 2016 Pawan Araballi. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import CoreData
import MGSwipeTableCell

class PlayListTableViewController: UITableViewController {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
//    let preferences = NSUserDefaults.standardUserDefaults().dictionaryRepresentation()
//    
//    var audioData = [String]()
    
    @IBAction func clearAll(sender: UIBarButtonItem) {
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "ListEntity")
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.deleteObject(managedObjectData)
            }
            
        } catch let error as NSError {
            print("Detele all data in error")
        }
        var temp = [NSManagedObject]()
        appDelegate.playlistItems = temp
        tableView.reloadData()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(appDelegate.playlistItems.count)
        
    }
//
//    func playFileAtPath(path:String) {
//        
//        do {
//            
//            let url = path
//            
//            let fileURL = NSURL(string:url)
//            
//            let soundData = NSData(contentsOfURL:fileURL!)
//            
//            var audioPlayer = try AVAudioPlayer(data: soundData!)
//            
//            audioPlayer.prepareToPlay()
//            
//            audioPlayer.volume = 1.0
//            
//            
//            audioPlayer.play()
//            
//        } catch {
//            
//            print("Error getting the audio file")
//            
//        }
//        
//    }
    
    override func viewWillAppear(animated: Bool) {
        
        //var destination = AVPlayerViewController()
        
//        let item = appDelegate.playlistItems[0]
//        var ss = item.valueForKey("item") as! String
//        print(ss)
        //playFileAtPath(ss)
        
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "ListEntity")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            appDelegate.playlistItems = results as! [NSManagedObject]
        }catch{
            print("Error retrieving")
        }
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
        // #warning Incomplete implementation, return the number of rows
        return appDelegate.playlistItems.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("playlistCell", forIndexPath: indexPath) as! CustomPlayListCell

        let managedContext = appDelegate.managedObjectContext

        let item = appDelegate.playlistItems[indexPath.row]
        
        cell.audiotitle.text = item.valueForKey("item") as! String

        cell.rightButtons = [MGSwipeButton(title: "Delete", backgroundColor: UIColor.redColor(), callback: {
            (sender: MGSwipeTableCell!) -> Bool in
            managedContext.deleteObject(self.appDelegate.playlistItems[indexPath.row])
            self.appDelegate.playlistItems.removeAtIndex(indexPath.row)
            self.tableView.reloadData()
            
            return true
        })]
        cell.rightSwipeSettings.transition = MGSwipeTransition.Rotate3D

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

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController as! AVPlayerViewController
        
        let item = appDelegate.playlistItems[tableView.indexPathForSelectedRow!.row]
        
        
        let url = NSURL(string:
            item.valueForKey("item") as! String)
        destination.player = AVPlayer(URL: url!)
        destination.player?.play()

        
    }

}
