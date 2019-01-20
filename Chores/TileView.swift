//
//  TileView.swift
//  Chores
//
//  Created by Jason Ellul on 2019-01-19.
//  Copyright © 2019 Jason Ellul. All rights reserved.
//

import UIKit
import Firebase

private let garbageImage = #imageLiteral(resourceName: "delete.png")
private let recycleImage = #imageLiteral(resourceName: "recycle.png")
private let notificationImage = #imageLiteral(resourceName: "notifications.png")
private let checkImage = #imageLiteral(resourceName: "check.png")

class TileView: UIView {
    
    static let kGarbageListPath = "garbage"
    let garbageReference = Database.database().reference(withPath: kGarbageListPath)
    static let kRecyclingListPath = "recycling"
    let recyclingReference = Database.database().reference(withPath: kRecyclingListPath)
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.font = UIFont(name: "Raleway-Bold", size: 20)
        label.textAlignment = .center
        return label
    }()

    let loadingBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var loadingBarWidthConstraint = loadingBar.widthAnchor.constraint(equalToConstant: 0)

    var longPressRecognizer: UILongPressGestureRecognizer! = nil
    
    //initWithFrame to init view from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()

    }
    
    func setupSubviews() {
        // tile interaction and styling
        isUserInteractionEnabled = true
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 5
        layer.cornerRadius = 10
        
        addSubview(imageView)
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -50).isActive = true
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        // add gesture recognizer
        longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(tapGestureAction(_:)))
        longPressRecognizer.minimumPressDuration = 0.0
        longPressRecognizer.isEnabled = true
        addGestureRecognizer(longPressRecognizer)
    }
    
    // call after tag is set
    func setupImageView() {
        switch tag {
        case 1:
            imageView.image = imageView.resizeImage(image: garbageImage, targetSize: CGSize(width: 80, height: 80))
        case 2:
            imageView.image = imageView.resizeImage(image: notificationImage, targetSize: CGSize(width: 80, height: 80))
        case 3:
            imageView.image = imageView.resizeImage(image: recycleImage, targetSize: CGSize(width: 80, height: 80))
        case 4:
            imageView.image = imageView.resizeImage(image: notificationImage, targetSize: CGSize(width: 80, height: 80))
        default:
            imageView.image = nil
        }
        
    }
    // call after text is setup
    func setupLabel() {
        addSubview(label)
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 45).isActive = true
        label.widthAnchor.constraint(equalToConstant: frame.width - 20).isActive = true
        label.heightAnchor.constraint(equalToConstant: (frame.height / 2) - 20).isActive = true
        // bottom View for style
       /* let bottomView = UIView()
        bottomView.translatesAutoresizingMaskIntoConstraints = true
        bottomView.backgroundColor = UIColor.white
        bottomView.layer.masksToBounds = true
        addSubview(bottomView)
        bottomView.frame = CGRect(x: 0, y: frame.height - 10, width: frame.width, height: 10)*/
        // add loading bar
        addSubview(loadingBar)
        loadingBar.topAnchor.constraint(equalTo: topAnchor, constant: frame.height - 45).isActive = true
        loadingBar.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        loadingBarWidthConstraint.isActive = true
        loadingBar.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    fileprivate var timer: Timer?
    var counter: Float = 0

    @objc func tapGestureAction(_ sender: UILongPressGestureRecognizer) {

        if sender.state == .began {
            print ("tapped")
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: (#selector(updateTimer(_:))), userInfo: nil, repeats: true)
            let smaller = CGAffineTransform(scaleX: 0.92, y: 0.92)
            UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut, animations: {
                self.transform = smaller
            }) { (completed) in
                
            }
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.loadingBarWidthConstraint.constant = self.bounds.width
                self.layoutIfNeeded()
            })
            
        }
        if sender.state == .ended || sender.state == .cancelled {
            print ("canceled")
            timer?.invalidate()
            counter = 0.0
            
            UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut, animations: {
                self.transform = .identity
            }) { (completed) in
                
            }
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: {
                self.loadingBarWidthConstraint.constant = 0
                self.layoutIfNeeded()
            })
        }

        
    }
        
    @objc func updateTimer(_ sender: Any) {
        print ("spam")
        counter += 0.1
        
        // trigger event
        if counter > 0.3 {
            timer?.invalidate()
            // enable and disable
            loadingBarWidthConstraint.constant = 0
            layoutIfNeeded()
            longPressRecognizer.isEnabled = false
            print ("success")
            animateSuccess()
        }
    }
    
    func animateSuccess() {

        let greenView = UIView(frame: bounds)
        greenView.translatesAutoresizingMaskIntoConstraints = true
        greenView.backgroundColor = UIColor(red:0.42, green:0.76, blue:0.35, alpha:1.0)
        greenView.alpha = 0.0
        greenView.layer.cornerRadius = 10
        addSubview(greenView)
        let imageView = UIImageView(frame: bounds)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = imageView.resizeImage(image: checkImage, targetSize: CGSize(width: 70, height: 70))
        imageView.alpha = 0.0
        addSubview(imageView)
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseIn, animations: {
            greenView.alpha = 1.0
            imageView.alpha = 1.0
            self.layer.borderColor = UIColor(red:0.42, green:0.76, blue:0.35, alpha:1.0).cgColor
        }) { (completed) in
            
        }
        let expandTransform: CGAffineTransform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        UIView.animate(withDuration: 1.2, delay: 0.0, usingSpringWithDamping: 0.25, initialSpringVelocity: 0.25, options: .curveEaseOut, animations: {
            imageView.transform = expandTransform.inverted()
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2, execute: {
            UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut, animations: {
                greenView.alpha = 0.0
                imageView.alpha = 0.0
                self.layer.borderColor = UIColor.white.cgColor
            }) { (completed) in
                // green animation completed, enable gesture and send messages
                greenView.removeFromSuperview()
                imageView.removeFromSuperview()
                self.longPressRecognizer.isEnabled = true
                // do the database action depending on the tile's tag
                self.performAction()
            }
        })
        
    }
    
    func performAction() {
        guard let fcmToken = Messaging.messaging().fcmToken else { return }
        let timestamp = Int64(NSDate().timeIntervalSince1970 * 1000)
        switch tag {
        case 1:
            // i just took out the garbage
            garbageReference.child(fcmToken).setValue(timestamp)
            print (timestamp)
        case 2:
            print (tag)
        case 3:
            // i just took out the recycling
            recyclingReference.child(fcmToken).setValue(timestamp)
            print (timestamp)
        case 4:
            print (tag)
        default:
            return
        }
    }
    

}
