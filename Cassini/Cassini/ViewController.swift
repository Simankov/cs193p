//
//  ViewController.swift
//  Cassini
//
//  Created by admin on 17/10/15.
//  Copyright (c) 2015 A. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
  
    struct SegueIdentifiers{
        static let Skopina  = "Skopina Segue"
        static let SPBU = "Spbu Segue"
        static let Cathedral = "Cathedral Segue"
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifer = segue.identifier{
            if let imageViewController = segue.destinationViewController as? ImageViewController{
                switch identifer{
                case SegueIdentifiers.Skopina:
                    imageViewController.imageURL = DemoURL.Skopina
                case SegueIdentifiers.SPBU:
                    imageViewController.imageURL = DemoURL.SPBU
                case SegueIdentifiers.Cathedral:
                    imageViewController.imageURL = DemoURL.SaintIsaacsCathedral
                default: break
                    
                }
            }
        }
    }
    
}
