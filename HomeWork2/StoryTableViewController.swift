//
//  StoryTableViewController.swift
//  HomeWork2
//
//  Created by student on 7/23/16.
//  Copyright © 2016 Pawan Araballi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
//import Concorde
import SDWebImage
import AVFoundation
import AVKit
import MGSwipeTableCell
import CoreData

class StoryTableViewController: UITableViewController, AVAudioPlayerDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    //let preferences = NSUserDefaults.standardUserDefaults()
    
    var accessCode = "MDI1NDQ5MjEzMDE0NjkyMjYyMDk3OWZlZQ000"
    
    var programId = ""
    var storiesData = [Story]()

    //For Core Data storage
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(programId)
        accessStories()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func accessStories() {
        let url = "http://api.npr.org/query?id=\(programId)&dateType=story&output=JSON&apiKey=\(accessCode)"
        print(url)
        //print(url)
        Alamofire.request(.GET, url).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    //print(json)
                    self.loadStories(json)
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    func loadStories(json : JSON ) {
        let stories = json["list"]["story"]
        
        for (index, object) in stories {
            
            var ids:String = ""
            var smallI:String = ""
            var largeI:String = ""
            var title:String = ""
            var pubDate:String = ""
            var teaser:String = ""
            var audioFile:String = ""
            
            if let title1 = object["id"].string {
                ids = title1
            }else {
                print(object["title"].error)
            }
            
            if let title1 = object["title"]["$text"].string {
                title = title1
            }else {
                print(object["title"]["$text"].error)
            }
            
            if let pubDate1 = object["pubDate"]["$text"].string {
                pubDate = pubDate1
            }else {
                print(object["pubDate"]["$text"].error)
            }
            
            
            if let smallImage = object["thumbnail"]["medium"]["$text"].string {
                smallI = smallImage
            }else{
                print(object["thumbnail"]["medium"]["$text"].error)
            }
            
            if let largeImage = object["thumbnail"]["large"]["$text"].string {
                largeI = largeImage
            }else{
                print(object["thumbnail"]["large"]["$text"].error)
            }
            if let teaser1 = object["teaser"]["$text"].string {
                teaser = teaser1
            }else{
                print(object["teaser"]["$text"].error)
            }

            if let audioFile1 = object["audio"][0]["format"]["mp3"][0]["$text"].string {
                audioFile = audioFile1
            }else {
                print(object["audio"][0]["format"]["mp3"][0]["$text"].error)
            }
            
            //print(ids)

            
            storiesData.append(Story(id:ids,title: title,pubDate: pubDate,smallI: smallI,largeI: largeI,teaser: teaser,audioFile: audioFile))
            
        }
        
        tableView.reloadData()
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if storiesData.count == 0 {
            return 0
        }else{
            return storiesData.count
        }
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if storiesData[indexPath.row].smallI == "" && storiesData[indexPath.row].largeI == ""  {
            let cell = tableView.dequeueReusableCellWithIdentifier("storyCellwithoutImage", forIndexPath: indexPath) as! CustomStorywithoutImageCell
            
            cell.title.text = storiesData[indexPath.row].title
            cell.pubDate.text = storiesData[indexPath.row].pubDate
            cell.desc.text = storiesData[indexPath.row].teaser
            
            cell.rightButtons = [MGSwipeButton(title: "Enqueue", backgroundColor: UIColor.redColor(), callback: {
                (sender: MGSwipeTableCell!) -> Bool in

                self.saveItem(self.storiesData[indexPath.row].audioFile)
                return true
            })]
            cell.rightSwipeSettings.transition = MGSwipeTransition.Rotate3D
            return cell
        }

        
        let cell = tableView.dequeueReusableCellWithIdentifier("storyCell", forIndexPath: indexPath) as! CustomStoryTableViewCell
        
        let imageURL = NSURL(string: storiesData[indexPath.row].smallI )
        if let url = imageURL {
            cell.iv.sd_setImageWithURL(url)
        }

        cell.title.text = storiesData[indexPath.row].title
        cell.pubDate.text = storiesData[indexPath.row].pubDate

        cell.rightButtons = [MGSwipeButton(title: "Enqueue", backgroundColor: UIColor.redColor(), callback: {
            (sender: MGSwipeTableCell!) -> Bool in
            self.saveItem(self.storiesData[indexPath.row].audioFile)
            
            return true
        })]
        cell.rightSwipeSettings.transition = MGSwipeTransition.Rotate3D
        

        return cell
    }
    
    func saveItem(itemToSave : String) {
        let managedContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("ListEntity", inManagedObjectContext: managedContext)
        
        let item = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        item.setValue(itemToSave, forKey: "item")
        
        do{
            try managedContext.save()
            
            appDelegate.playlistItems.append(item)
        }catch {
            print("error")
        }
        
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
        let destination = segue.destinationViewController as! AVPlayerViewController
        let url = NSURL(string:
            storiesData[tableView.indexPathForSelectedRow!.row].audioFile)
        destination.player = AVPlayer(URL: url!)
        destination.player?.play()
    }
 

}
