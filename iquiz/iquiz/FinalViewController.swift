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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (numCorrect == 2) {
            lblCongrats.text = "Perfect!"
        } else if (numCorrect == 1) {
            lblCongrats.text = "So close!"
        } else if (numCorrect == 0){
            lblCongrats.text = "Yikes..."
        }
        lblNumCorrect.text = "Final Score: " + String(numCorrect) + " / 2"
    }
   
    @IBOutlet weak var lblNumCorrect: UILabel!
    @IBOutlet weak var lblCongrats: UILabel!
    
    @IBAction func btnReturn(_ sender: Any) {
        performSegue(withIdentifier: "toStart", sender: self)
    }
    
    public func setIncoming(incoming: Int) {
        numCorrect = incoming
    }
    
}
