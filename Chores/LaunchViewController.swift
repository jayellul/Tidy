//
//  LaunchViewController.swift
//  Chores
//
//  Created by Jason Ellul on 2019-01-18.
//  Copyright © 2019 Jason Ellul. All rights reserved.
//

import UIKit
import Firebase

private let garbageImage = #imageLiteral(resourceName: "delete.png")

class LaunchViewController: UIViewController {
    // firebase db refs
    static let kUsersListPath = "users"
    let usersReference = Database.database().reference(withPath: kUsersListPath)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGradientToView(view)
        
        // Do any additional setup after loading the view.
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = imageView.resizeImage(image: garbageImage, targetSize: CGSize(width: view.frame.width - 100, height: view.frame.width - 100))
        view.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        checkFirebase()
    }
    
    func checkFirebase() {
        guard let fcmToken = Messaging.messaging().fcmToken else { segueToName(); return }
        usersReference.child(fcmToken).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "segueToTile", sender: nil)
                }
            } else {
                self.segueToName()
            }
        }

    }
    
    func segueToName() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "segueToName", sender: nil)
        }
    }


}
