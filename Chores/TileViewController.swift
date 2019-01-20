//
//  TileViewController.swift
//  Chores
//
//  Created by Jason Ellul on 2019-01-19.
//  Copyright © 2019 Jason Ellul. All rights reserved.
//

import UIKit
import Firebase

class TileViewController: UIViewController, CustomTabBarDelegate {
    
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = UIColor.clear
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    let topLeftTile: TileView = {
        let tileView = TileView()
        tileView.translatesAutoresizingMaskIntoConstraints = false
        tileView.tag = 1
        return tileView
    }()
    
    let topRightTile: TileView = {
        let tileView = TileView()
        tileView.translatesAutoresizingMaskIntoConstraints = false
        tileView.tag = 2
        return tileView
    }()
    
    let bottomLeftTile: TileView = {
        let tileView = TileView()
        tileView.translatesAutoresizingMaskIntoConstraints = false
        tileView.tag = 3
        return tileView
    }()
    
    let bottomRightTile: TileView = {
        let tileView = TileView()
        tileView.translatesAutoresizingMaskIntoConstraints = false
        tileView.tag = 4
        return tileView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addGradientToView(view)
        setupSubviews()
    }
    
    func setupSubviews() {
        view.addSubview(scrollView)
        scrollView.frame = view.frame
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        // add tiles
        scrollView.addSubview(topLeftTile)
        topLeftTile.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: (scrollView.frame.width / 2) - 15, height: (scrollView.frame.height / 2) - 50)
        topLeftTile.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10).isActive = true
        topLeftTile.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10).isActive = true
        topLeftTile.heightAnchor.constraint(equalToConstant: (scrollView.frame.height / 2) - 50).isActive = true
        topLeftTile.widthAnchor.constraint(equalToConstant: (scrollView.frame.width / 2) - 15).isActive = true
        topLeftTile.label.text = "I just took out the Garbage"
        topLeftTile.setupLabel()
        topLeftTile.setupImageView()
        
        scrollView.addSubview(topRightTile)
        topRightTile.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: (scrollView.frame.width / 2) - 15, height: (scrollView.frame.height / 2) - 50)
        topRightTile.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: scrollView.frame.width - 10).isActive = true
        topRightTile.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10).isActive = true
        topRightTile.heightAnchor.constraint(equalToConstant: (scrollView.frame.height / 2) - 50).isActive = true
        topRightTile.widthAnchor.constraint(equalToConstant: (scrollView.frame.width / 2) - 15).isActive = true
        topRightTile.label.text = "Loading..."
        topRightTile.setupLabel()
        topRightTile.setupImageView()

        scrollView.addSubview(bottomLeftTile)
        bottomLeftTile.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: (scrollView.frame.width / 2) - 15, height: (scrollView.frame.height / 2) - 50)
        bottomLeftTile.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10).isActive = true
        bottomLeftTile.topAnchor.constraint(equalTo: scrollView.centerYAnchor, constant: -15).isActive = true
        bottomLeftTile.heightAnchor.constraint(equalToConstant: (scrollView.frame.height / 2) - 50).isActive = true
        bottomLeftTile.widthAnchor.constraint(equalToConstant: (scrollView.frame.width / 2) - 15).isActive = true
        bottomLeftTile.label.text = "I just took out the Recycling"
        bottomLeftTile.setupLabel()
        bottomLeftTile.setupImageView()

        scrollView.addSubview(bottomRightTile)
        bottomRightTile.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: (scrollView.frame.width / 2) - 15, height: (scrollView.frame.height / 2) - 50)
        bottomRightTile.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: scrollView.frame.width - 10).isActive = true
        bottomRightTile.topAnchor.constraint(equalTo: scrollView.centerYAnchor, constant: -15).isActive = true
        bottomRightTile.heightAnchor.constraint(equalToConstant: (scrollView.frame.height / 2) - 50).isActive = true
        bottomRightTile.widthAnchor.constraint(equalToConstant: (scrollView.frame.width / 2) - 15).isActive = true
        bottomRightTile.label.text = "Loading..."
        bottomRightTile.setupLabel()
        bottomRightTile.setupImageView()

    }
    
    // tab bar updated
    func finishedLoading() {
        // get the last entries of the arrays and set as the name to remind
        if var newGarbageChores = (tabBarController as? CustomTabBarController)?.garbageChores {
            newGarbageChores.sort(by: { $0.time > $1.time})
            var topRightTileString = ""
            if let lastChore = newGarbageChores.last {
                if let fcmToken = Messaging.messaging().fcmToken {
                    if fcmToken == lastChore.fcmToken {
                        topRightTileString = "It's your turn to take out the Garbage!"
                    } else {
                        topRightTileString = "Remind " + lastChore.name  + " to take out the Garbage."
                    }
                } else {
                    topRightTileString = "Remind " + lastChore.name  + " to take out the Garbage."
                }
                topRightTile.label.text = topRightTileString
            }
         
        }
        
        if var newRecyclingChores = (tabBarController as? CustomTabBarController)?.recyclingChores {
            newRecyclingChores.sort(by: { $0.time > $1.time})
            var bottomRightTileString = ""
            if let lastChore = newRecyclingChores.last {
                if let fcmToken = Messaging.messaging().fcmToken {
                    if fcmToken == lastChore.fcmToken {
                        bottomRightTileString = "It's your turn to take out the Recycling!"
                    } else {
                        bottomRightTileString = "Remind " + lastChore.name  + " to take out the Recycling."
                    }
                } else {
                    bottomRightTileString = "Remind " + lastChore.name  + " to take out the Recycling."
                }
                bottomRightTile.label.text = bottomRightTileString
            }
        }
   
    }
    

}

extension TileViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
