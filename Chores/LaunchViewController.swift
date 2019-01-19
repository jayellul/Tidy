//
//  LaunchViewController.swift
//  Chores
//
//  Created by Jason Ellul on 2019-01-18.
//  Copyright © 2019 Jason Ellul. All rights reserved.
//

import UIKit


private let garbageImage = #imageLiteral(resourceName: "delete.png")

class LaunchViewController: UIViewController {

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
        
    }


}
