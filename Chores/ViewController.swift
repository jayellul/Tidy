//
//  ViewController.swift
//  Chores
//
//  Created by Jason Ellul on 2019-01-18.
//  Copyright © 2019 Jason Ellul. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocorrectionType = .no
        textField.textColor = UIColor.white
        textField.backgroundColor = UIColor.clear
        textField.font = UIFont.systemFont(ofSize: 20.0)
        textField.textAlignment = .center
        textField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.text = ""
        textField.tag = 0
        textField.keyboardType = UIKeyboardType.default
        // add bottom line
        let view = UIView(frame: CGRect(x: 0, y: 26, width: 0, height: 0))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor.white
        textField.addSubview(view)
        view.centerXAnchor.constraint(equalTo: textField.centerXAnchor).isActive = true
        view.widthAnchor.constraint(equalTo: textField.widthAnchor).isActive = true
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.topAnchor.constraint(equalTo: textField.bottomAnchor).isActive = true
        
        return textField
    }()
    
    let button: LoadingButton = {
        let button = LoadingButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
        button.backgroundColor = UIColor.clear
        button.layer.cornerRadius = 25
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.5
        button.activityIndicator.color = UIColor.white
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGradientToView(view)
        // add ui components
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 50, height: 30))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.numberOfLines = 1
        view.addSubview(label)
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.frame.height / -3).isActive = true
        label.widthAnchor.constraint(equalToConstant: view.frame.width - 50).isActive = true
        
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.text = "Welcome"
        
        let label2 = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 50, height: 30))
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.textColor = UIColor.white
        label2.numberOfLines = 0
        view.addSubview(label2)
        label2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label2.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.frame.height / -3.75).isActive = true
        label2.widthAnchor.constraint(equalToConstant: view.frame.width - 50).isActive = true
        
        label2.font = UIFont.systemFont(ofSize: 20)
        label2.text = "Please enter your name below:"
        
        view.addSubview(textField)
        textField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -75).isActive = true
        textField.widthAnchor.constraint(equalToConstant: view.frame.width - 50).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        view.addSubview(button)
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: view.frame.width - 50).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }


}

// helper functions
extension UIViewController {
    func addGradientToView(_ view: UIView) {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(red:0.16, green:0.24, blue:0.53, alpha:1.0).cgColor, UIColor(red:0.27, green:0.64, blue:0.28, alpha:1.0).cgColor]
        //gradient.colors = [UIColor(red:1.00, green:0.42, blue:0.00, alpha:1.0).cgColor, UIColor(red:0.93, green:
        gradient.frame = view.bounds
        let angle: Double = 146
        let x: Double! = angle / 360.0
        let a = pow(sinf(Float(2.0 * .pi * ((x + 0.75) / 2.0))), 2.0)
        let b = pow(sinf(Float(2 * .pi * ((x + 0.0) / 2))), 2)
        let c = pow(sinf(Float(2 * .pi * ((x + 0.25) / 2))), 2)
        let d = pow(sinf(Float(2 * .pi * ((x + 0.5) / 2 ))), 2)
        
        gradient.endPoint = CGPoint(x: CGFloat(c),y: CGFloat(d))
        gradient.startPoint = CGPoint(x: CGFloat(a),y:CGFloat(b))
        
        view.layer.insertSublayer(gradient, at: 0)
    }

}

extension UIImageView {
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
