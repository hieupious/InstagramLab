//
//  ViewController.swift
//  Instagram
//
//  Created by Ngoc Do on 3/9/16.
//  Copyright © 2016 com.appable. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var listData: [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        fetchData()
        tableView.rowHeight = 320
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("refreshControlAction:"), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func fetchData() {
        let clientId = "e05c462ebd86446ea48a5af73769b602"
        let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            NSLog("response: \(responseDictionary)")
                            self.listData = (responseDictionary["data"] as? [NSDictionary])!
                            self.tableView.reloadData()
                    }
                }
        });
        task.resume()

    }
    
    func refreshControlAction(refreshControl:UIRefreshControl){
        fetchData()
        refreshControl.endRefreshing()
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return listData.count ?? 0
    }

    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).CGColor
        profileView.layer.borderWidth = 1;
        
        if listData.count > 0 {
            // Use the section number to get the right URL
            let urlStr:String = (listData[section]["user"]?["profile_picture"] as? String)!
            let url = NSURL(string: urlStr)
            profileView.setImageWithURL(url!)
            
            headerView.addSubview(profileView)
            
            // Add a UILabel for the username here)
            let usernameLabel = UILabel(frame: CGRect(x:60, y: 0, width: 260, height: 50))
            let username = listData[section]["user"]?["username"] as? String
            usernameLabel.text = username
            
            headerView.addSubview(usernameLabel)
        }
        
        return headerView
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! dataCell
        if listData.count > 0 {
            let urlStr:String = (listData[indexPath.section]["images"]?["low_resolution"]?!["url"] as? String)!
            let url = NSURL(string: urlStr)
            cell.dataImage.setImageWithURL(url!)
        }
        
        return cell
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("hello")
        var vc = segue.destinationViewController as! PhotoDetailsViewController
        var indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
        let urlStr:String = (listData[indexPath!.row]["images"]?["low_resolution"]?!["url"] as? String)!
        let url = NSURL(string: urlStr)
        vc.url = url
    }

}

