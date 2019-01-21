//
//  CustomTabBarControllerViewController.swift
//  Chores
//
//  Created by Jason Ellul on 2019-01-19.
//  Copyright © 2019 Jason Ellul. All rights reserved.
//

import UIKit
import Firebase

protocol CustomTabBarDelegate {
    func finishedLoading()
}

class CustomTabBarController: UITabBarController {
    // firebase db refs
    static let kUsersListPath = "users"
    let usersReference = Database.database().reference(withPath: kUsersListPath)
    static let kGarbageListPath = "garbage"
    let garbageReference = Database.database().reference(withPath: kGarbageListPath)
    static let kRecyclingListPath = "recycling"
    let recyclingReference = Database.database().reference(withPath: kRecyclingListPath)
    
    // delegates to notify subviews data was retrieved
    var tileViewControllerDelegate: CustomTabBarDelegate?
    var historyViewControllerDelegate: CustomTabBarDelegate?

    var garbageChores: [Chore] = []
    var recyclingChores: [Chore] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // make viewcontrollers delegates
        let tileViewController = self.viewControllers![0] as! TileViewController
        let historyViewController = self.viewControllers![1] as! HistoryViewController
        
        tileViewControllerDelegate = tileViewController
        historyViewControllerDelegate = historyViewController

        loadChores()
    }
    
    // observe chores from firebase
    func loadChores() {
        // observe to get realtime updates
        garbageReference.observe(.value) { (snapshot) in
            var garbageChores: [Chore] = []
            if snapshot.exists() {
                var snapshotArray = [DataSnapshot]()
                // get all snapshots
                for item in snapshot.children {
                    let snap = item as! DataSnapshot
                    snapshotArray.append(snap)
                }
                // async dispatch group
                let myGroup = DispatchGroup()
                for (_ , choreSnapshot) in snapshotArray.enumerated() {
                    myGroup.enter()
                    self.usersReference.child(choreSnapshot.key).observeSingleEvent(of: .value, with: { (innerSnapshot) in
                        if innerSnapshot.exists() {
                            if let time = choreSnapshot.value as? Int64 {
                                if let name = innerSnapshot.value as? String {
                                    let chore = Chore(name: name, type: 0, time: time, fcmToken: innerSnapshot.key)
                                    garbageChores.append(chore)
                                }
                            }
                        }
                        myGroup.leave()
                    })
                }
                myGroup.notify(queue: .main) {
                    garbageChores.sort(by: { $0.time > $1.time})
                    self.garbageChores = garbageChores
                    self.tileViewControllerDelegate?.finishedLoading()
                    self.historyViewControllerDelegate?.finishedLoading()
                }
            } else {
                garbageChores.sort(by: { $0.time > $1.time})
                self.garbageChores = garbageChores
                self.tileViewControllerDelegate?.finishedLoading()
                self.historyViewControllerDelegate?.finishedLoading()
            }
            
        }
        recyclingReference.observe(.value) { (snapshot) in
            var recyclingChores: [Chore] = []
            if snapshot.exists() {
                var snapshotArray = [DataSnapshot]()
                // get all snapshots
                for item in snapshot.children {
                    let snap = item as! DataSnapshot
                    snapshotArray.append(snap)
                }
                // async dispatch group
                let myGroup = DispatchGroup()
                for (_ , choreSnapshot) in snapshotArray.enumerated() {
                    myGroup.enter()
                    self.usersReference.child(choreSnapshot.key).observeSingleEvent(of: .value, with: { (innerSnapshot) in
                        if innerSnapshot.exists() {
                            if let time = choreSnapshot.value as? Int64 {
                                if let name = innerSnapshot.value as? String {
                                    let chore = Chore(name: name, type: 1, time: time, fcmToken: innerSnapshot.key)
                                    recyclingChores.append(chore)
                                }
                            }
                        }
                        myGroup.leave()
                    })
                }
                myGroup.notify(queue: .main) {
                    recyclingChores.sort(by: { $0.time > $1.time})
                    self.recyclingChores = recyclingChores
                    self.tileViewControllerDelegate?.finishedLoading()
                    self.historyViewControllerDelegate?.finishedLoading()
                }
            } else {
                recyclingChores.sort(by: { $0.time > $1.time})
                self.recyclingChores = recyclingChores
                self.tileViewControllerDelegate?.finishedLoading()
                self.historyViewControllerDelegate?.finishedLoading()
            }
            
        }
        
    }

}
