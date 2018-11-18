//
//  QuestionViewController.swift
//  iquiz
//
//  Created by Nicholas Olds on 11/8/18.
//  Copyright © 2018 Nicholas Olds. All rights reserved.
//

import UIKit

var quiz : Quiz = Quiz(image: UIImage(named: "soccer.jpeg"), title: "", description: "", qs: [QuizQuestions(question: "", answers: [], correct: 0), QuizQuestions(question: "", answers: [], correct: 0)], numCorrect: 0, done: false, curQ: 0)

var numAnswered = -1

class QuestionViewController: UIViewController, UITableViewDelegate {

    
    public func setIncoming(incoming: Quiz) {
        quiz = incoming
        incomingText = incoming.qs[Int(quiz.curQ)].question
    }
    public var incomingText: String = "Answer"

    @IBAction func backTo(_ sender: Any) {
        performSegue(withIdentifier: "segueBackHome", sender: self)
    }
    
    @IBAction func swipeSubmit(_ sender: Any) {
        if (numAnswered > -1) {
            performSegue(withIdentifier: "toAnswer", sender: self)
        }
    }
    
    @IBAction func swipeBack(_ sender: Any) {
        performSegue(withIdentifier: "segueBackHome", sender: self)
    }
    
    @IBAction func btnAnswer(_ sender: Any) {
        if (numAnswered > -1) {
            performSegue(withIdentifier: "toAnswer", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "toAnswer":
            let destination = segue.destination as! AnswerViewController
            destination.setIncoming(incoming: quiz, numAnswer: numAnswered)
        default:
            NSLog("Unknown segue identifier -- " + segue.identifier!)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        numAnswered = row // saying which answer was selected by num
    }
    @IBOutlet weak var question: UILabel!
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
        return (quiz.qs[Int(quiz.curQ)].answers.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "NameTableIdentifier")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "NameTableIdentifier")
        }
        cell?.textLabel?.text = quiz.qs[Int(quiz.curQ)].answers[indexPath.row]
    
        return cell!
    }
    
    
}

