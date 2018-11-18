//
//  FinalViewController.swift
//  iquiz
//
//  Created by Nicholas Olds on 11/9/18.
//  Copyright © 2018 Nicholas Olds. All rights reserved.
//

import UIKit

class FinalViewController: UIViewController {
    
    var numCorrect : Int = -1
    var size : Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let percent = (Double(numCorrect) * 1.0) / (Double(size) * 1.0) * 100.00
        
        if (percent >= 90.0) {
            lblCongrats.text = "Perfect!"
        } else if (percent >= 50.0) {
            lblCongrats.text = "So close!"
        } else {
            lblCongrats.text = "Yikes..."
        }
        lblNumCorrect.text = "Final Score: " + String(numCorrect) + " / " + String(size)
    }
   
    @IBAction func swipeLeft(_ sender: Any) {
        performSegue(withIdentifier: "toStart", sender: self)
    }
    @IBOutlet weak var lblNumCorrect: UILabel!
    @IBOutlet weak var lblCongrats: UILabel!
    
    @IBAction func btnReturn(_ sender: Any) {
        performSegue(withIdentifier: "toStart", sender: self)
    }
    
    public func setIncoming(incoming: Int, qsSize: Int) {
        size = qsSize
        numCorrect = incoming
    }
    
}
