//
//  ViewController.swift
//  Autolayout
//
//  Created by admin on 17/10/15.
//  Copyright (c) 2015 A. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var password: UILabel!
    
    var loggedUser: User?{
        didSet{
            updateUI()
        }
    }
    var secure:Bool = false{
        didSet{
            updateUI()
        }
    }

    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var aspectRatioConstraint:NSLayoutConstraint?{
        didSet{
            if let constraint = aspectRatioConstraint{
                imageView.addConstraint(constraint)
            }
        }
        
        willSet{
            if let existingConstraint = newValue{
                imageView.removeConstraint(existingConstraint)
                
            }
        }
    }
     
    @IBOutlet weak var imageView: UIImageView!
  
    
    var image: UIImage?{
        set{
            imageView?.image = newValue
            if let constrainedView = imageView{
                if let newImage = newValue{
                    aspectRatioConstraint = NSLayoutConstraint(
                        item: constrainedView,
                        attribute: .Width,
                        relatedBy: NSLayoutRelation.Equal,
                        toItem: constrainedView,
                        attribute: NSLayoutAttribute.Height,
                        multiplier: newImage.aspectRatio,
                        constant: 0)
                } else {
                    aspectRatioConstraint = nil
                }
            }
        }
        
        get{
            return imageView.image
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        updateUI()
    }
    @IBAction func login() {
        loggedUser = User.login(usernameField.text ?? "", password: passwordField.text ?? "")
    }
    func updateUI(){
        passwordField.secureTextEntry = secure
        password.text = secure ? "Secured Password" : "Password"
        nameLabel.text = loggedUser?.name
        companyLabel.text  = loggedUser?.company
        image = loggedUser?.image
    }
    
    @IBAction func toggleSecure() {
        secure = !secure
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    

}

extension User {
    var image: UIImage?{
        get{
            if let image = UIImage(named: login){
                return image
            }
            return UIImage(named: "UnknownUser")
        }
    }
}

extension UIImage {
    var aspectRatio: CGFloat{
        get{
            return size.height == 0 ? 0 :  size.width/size.height
        }
    }
}

