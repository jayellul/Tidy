//
//  HistoryViewController.swift
//  Chores
//
//  Created by Jason Ellul on 2019-01-19.
//  Copyright © 2019 Jason Ellul. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, CustomTabBarDelegate  {

    
    
    private let reuseIdentifier = "reuse"

    var chores: [Chore] = []

    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.alwaysBounceVertical = true
        tableView.showsVerticalScrollIndicator =  true
        tableView.alwaysBounceHorizontal = false
        tableView.showsHorizontalScrollIndicator = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addGradientToView(view)
        setupSubviews()
    }
    
    func setupSubviews() {
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 30))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Raleway-Bold", size: 25)
        label.textColor = UIColor.white
        label.text = "Chore History"
        view.addSubview(label)
        label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        label.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(tableView)
        tableView.frame = view.frame
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView (frame: CGRect.zero)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
    }
    
    // tab bar updated
    func finishedLoading() {
        if let newGarbageChores = (tabBarController as? CustomTabBarController)?.garbageChores {
            if let newRecylingChores = (tabBarController as? CustomTabBarController)?.recyclingChores {
                chores = newGarbageChores + newRecylingChores
            }
        }
        chores.sort(by: { $0.time > $1.time})
        tableView.reloadData()
    }

}

extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // initialize cell and add chore data to it
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) {
            cell.backgroundColor = cell.contentView.backgroundColor
            cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            cell.isUserInteractionEnabled = false
            cell.frame.size.width = tableView.frame.width
            // remove for overlap when cells refresh
            for subview in cell.subviews {
                if subview is UILabel {
                    subview.removeFromSuperview()
                }
            }
            // add name label
            let nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            nameLabel.font = UIFont.systemFont(ofSize: 16)
            nameLabel.textColor = UIColor.white
            cell.addSubview(nameLabel)
            nameLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            nameLabel.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 20).isActive = true
            nameLabel.widthAnchor.constraint(equalToConstant: cell.frame.width - 100).isActive = true
            nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
            let chore = chores[indexPath.row]
            if chore.type == 0 {
                nameLabel.text = chore.name + " took out the Garbage."
            } else if chore.type == 1 {
                nameLabel.text = chore.name + " took out the Recycling."
            }
            // add time label
            let timeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
            timeLabel.translatesAutoresizingMaskIntoConstraints = false
            timeLabel.font = UIFont.systemFont(ofSize: 16)
            timeLabel.textColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
            timeLabel.textAlignment = .right
            cell.addSubview(timeLabel)
            timeLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            timeLabel.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: cell.frame.width - 220).isActive = true
            timeLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
            timeLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
            timeLabel.text = timeLabel.timestampToText(timestamp: chore.time)
            return cell
        } else {
            // fatal error
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chores.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
