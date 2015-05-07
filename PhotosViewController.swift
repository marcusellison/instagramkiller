//
//  PhotosViewController.swift
//  InstagramKiller
//
//  Created by Marcus J. Ellison on 5/6/15.
//  Copyright (c) 2015 Marcus J. Ellison. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var photos = NSArray()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self

        self.tableView.rowHeight = 320;
        
        let clientId = "3ad2ee5e60b141638b8a7fba61b499c3"
        
        let url = NSURL(string: "https://api.instagram.com/v1/media/popular?client_id=\(clientId)")!
        let request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) in
            var responseDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! NSDictionary
            
            self.photos = (responseDictionary["data"] as? NSArray)!
    
            self.tableView.reloadData()
            
            println("response: \(self.photos)")
        }

        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("com.codepath.gridphotoviewcell", forIndexPath: indexPath) as? PhotoViewCell
        
        let imageData = self.photos[indexPath.row] as! NSDictionary
        
        let username = (imageData.valueForKeyPath("user.username") as! String)
        let userProfileUrl = imageData.valueForKeyPath("user.profile_picture") as! String
        
        let imageUrl = imageData.valueForKeyPath("images.standard_resolution.url") as! String
        let imageNSUrl = NSURL(string: imageUrl)
        
        cell!.userNameLabel.text = username
        cell!.userProfileImageView.setImageWithURL(NSURL(string: userProfileUrl))
        cell!.photoCellView.setImageWithURL(imageNSUrl)
    
        return cell!
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
