//
//  AnswerViewController.swift
//  iquiz
//
//  Created by Nicholas Olds on 11/8/18.
//  Copyright © 2018 Nicholas Olds. All rights reserved.
//

import UIKit

class AnswerViewController: UIViewController {

    var quiz : Quiz = Quiz(image: UIImage(named: "soccer.jpeg"), title: "", description: "", qs: [QuizQuestions(question: "", answers: [], correct: 0), QuizQuestions(question: "", answers: [], correct: 0)], numCorrect: 0, done: false, curQ: 0)
    
    var numAnswered = -1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblQuestion.text = "Question: " + quiz.qs[Int(quiz.curQ)].question
        if (quiz.qs[Int(quiz.curQ)].correct == numAnswered) {
            lblCorrect.text = "Correct!"
            quiz.numCorrect = quiz.numCorrect + 1
        } else {
            lblCorrect.text = "Incorrect..."
        }
        lblAnswer.text = "Correct answer: " + quiz.qs[Int(quiz.curQ)].answers[Int(quiz.qs[Int(quiz.curQ)].correct)]
        lblYourAnswer.text = "Your answer: " + quiz.qs[Int(quiz.curQ)].answers[numAnswered]
    }
    
    @IBOutlet weak var lblYourAnswer: UILabel!
    @IBOutlet weak var lblAnswer: UILabel!
    @IBOutlet weak var lblCorrect: UILabel!
    @IBOutlet weak var lblQuestion: UILabel!
    
    @IBAction func btnReturnBack(_ sender: Any) {
        performSegue(withIdentifier: "toHome", sender: self)
    }
    
    @IBAction func swipeNext(_ sender: Any) {
        if (!quiz.done) {
            performSegue(withIdentifier: "toNextQuestion", sender: self)
        } else {
            performSegue(withIdentifier: "toFinal", sender: self)
        }
    }
    @IBAction func swipeBack(_ sender: Any) {
        performSegue(withIdentifier: "toHome", sender: self)
    }
    @IBAction func btnNextQuestion(_ sender: Any) {
        quiz.curQ = quiz.curQ + 1
        if (Int(quiz.curQ) < quiz.qs.count) {
            performSegue(withIdentifier: "toNextQuestion", sender: self)
        } else {
            performSegue(withIdentifier: "toFinal", sender: self)
        }
    
    }
    
    public func setIncoming(incoming: Quiz, numAnswer: Int) {
        quiz = incoming
        numAnswered = numAnswer
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "toNextQuestion":
            let destination = segue.destination as! QuestionViewController
            destination.setIncoming(incoming: quiz)
        case "toFinal":
            quiz.curQ = 0
            let destination = segue.destination as! FinalViewController
            destination.setIncoming(incoming: Int(quiz.numCorrect), qsSize: quiz.qs.count)
        default:
            NSLog("Unknown segue identifier -- " + segue.identifier!)
        }
    }

}
