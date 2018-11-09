//
//  QuestionViewController.swift
//  iquiz
//
//  Created by Nicholas Olds on 11/8/18.
//  Copyright © 2018 Nicholas Olds. All rights reserved.
//

import UIKit

var quiz : Quiz = Quiz(image: UIImage(named: "soccer.jpeg"), title: "", description: "", answers: ["", "", "", ""], correct: 1)

class QuestionViewController: UIViewController, UITableViewDelegate {

    
    public func setIncomingText(incoming: Quiz) {
        quiz = incoming
        NSLog(incoming.title)
        incomingText = incoming.title
    }
    
    @IBOutlet weak var question: UILabel!
    public var incomingText: String = "Answer"
    let dataSource = AnswerDataSource()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        question.text = incomingText
        tableView.dataSource = dataSource
        tableView.delegate = self
    }

}

class AnswerDataSource : NSObject, UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (quiz.answers.count)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "NameTableIdentifier")
        if cell == nil {
            NSLog("Creating new UITableViewCell")
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "NameTableIdentifier")
        }
        cell?.textLabel?.text = quiz.answers[indexPath.row]
    
        return cell!
    }
    
}

