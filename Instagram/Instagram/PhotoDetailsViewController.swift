//
//  PhotoDetailsViewController.swift
//  Instagram
//
//  Created by Hoang Trung Hieu on 3/9/16.
//  Copyright © 2016 com.appable. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {

    @IBOutlet weak var photoDetailsImageView: UIImageView!
    var url: NSURL?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoDetailsImageView.setImageWithURL(url!)
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
