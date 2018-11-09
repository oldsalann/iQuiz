//
//  AnswerViewController.swift
//  iquiz
//
//  Created by Nicholas Olds on 11/8/18.
//  Copyright © 2018 Nicholas Olds. All rights reserved.
//

import UIKit

class AnswerViewController: UIViewController {

    var quiz : Quiz = Quiz(image: UIImage(named: "soccer.jpeg"), title: "", description: "", q1: QuizQuestions(question: "", answers: [], correct: 0), q2: QuizQuestions(question: "", answers: [], correct: 0), numCorrect: 0, done: false)
    
    var numAnswered = -1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblQuestion.text = "Question: " + quiz.q1.question
        if (quiz.q1.correct == numAnswered) {
            lblCorrect.text = "Correct!"
            quiz.numCorrect = quiz.numCorrect + 1
        } else {
            lblCorrect.text = "Incorrect..."
        }
        lblAnswer.text = "Correct answer: " + quiz.q1.answers[Int(quiz.q1.correct)]
        lblYourAnswer.text = "Your answer: " + quiz.q1.answers[numAnswered]
    }
    
    @IBOutlet weak var lblYourAnswer: UILabel!
    @IBOutlet weak var lblAnswer: UILabel!
    @IBOutlet weak var lblCorrect: UILabel!
    @IBOutlet weak var lblQuestion: UILabel!
    
    @IBAction func btnReturnBack(_ sender: Any) {
        performSegue(withIdentifier: "toHome", sender: self)
    }
    
    @IBAction func swipeBack(_ sender: Any) {
        performSegue(withIdentifier: "toHome", sender: self)
    }
    @IBAction func btnNextQuestion(_ sender: Any) {
        if (!quiz.done) {
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
            let tempq1 = quiz.q1 // cycling for next question
            quiz.q1 = quiz.q2
            quiz.q2 = tempq1
            destination.setIncoming(incoming: quiz)
            quiz.done = true
        case "toFinal":
            let destination = segue.destination as! FinalViewController
            destination.setIncoming(incoming: Int(quiz.numCorrect))
        default:
            NSLog("Unknown segue identifier -- " + segue.identifier!)
        }
    }

}
