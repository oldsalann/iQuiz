//
//  ViewController.swift
//  iquiz
//
//  Created by Nicholas Olds on 10/30/18.
//  Copyright © 2018 Nicholas Olds. All rights reserved.
//

import UIKit

struct QuizList {
    var soccer = [Quiz(image: UIImage(named: "soccer.jpeg"), title: "Soccer History", description: "Do you know your soccer history?", q1: QuizQuestions(question: "Which national team has won the most World Cups?", answers: ["Brazil", "Italy", "Germany", "France"], correct: 0), q2: QuizQuestions(question: "Which national team won the first World Cup in 1930?", answers: ["Brazil", "Uruguay", "Argentina", "England"], correct: 1), numCorrect: 0, done: false)]
    var basketball = [Quiz(image: UIImage(named: "basket.jpg"), title: "Basketball History", description: "Do you know your basketball history? Find out now!", q1: QuizQuestions(question: "Who has scored the most points in NBA history?", answers: ["Michael Jordan", "Kareem Abdul-Jabar", "Karl Malone", "Lebron James"], correct: 1), q2: QuizQuestions(question: "Which team has one the most NBA championships?", answers: ["Chicago Bulls", "Los Angeles Lakers", "Boston Celtics", "Golden State Warriors"], correct: 2), numCorrect: 0, done: false)]
    var videogames = [Quiz(image: UIImage(named: "video.jpeg"), title: "Video Game History", description: "Test your video game history knowledge!", q1: QuizQuestions(question: "What was the first home console game, in 1972?", answers: ["Pong", "Tetris", "Asteroids", "Magnavox Odyssey"], correct: 3), q2: QuizQuestions(question: "What was the average age of video game players in 2011?", answers: ["16", "23", "44", "34"], correct: 3), numCorrect: 0, done: false)]
    var listOfQuizzes = [Quiz(image: UIImage(named: "soccer.jpeg"), title: "Soccer History", description: "Do you know your soccer history?", q1: QuizQuestions(question: "Which national team has won the most World Cups?", answers: ["Brazil", "Italy", "Germany", "France"], correct: 0), q2: QuizQuestions(question: "Which national team won the first World Cup in 1930?", answers: ["Brazil", "Uruguay", "Argentina", "England"], correct: 1), numCorrect: 0, done: false),
                                Quiz(image: UIImage(named: "basket.jpg"), title: "Basketball History", description: "Do you know your basketball history? Find out now!", q1: QuizQuestions(question: "Who has scored the most points in NBA history?", answers: ["Michael Jordan", "Kareem Abdul-Jabar", "Karl Malone", "Lebron James"], correct: 1), q2: QuizQuestions(question: "Which team has one the most NBA championships?", answers: ["Chicago Bulls", "Los Angeles Lakers", "Boston Celtics", "Golden State Warriors"], correct: 2), numCorrect: 0, done: false),
                                Quiz(image: UIImage(named: "video.jpeg"), title: "Video Game History", description: "Test your video game history knowledge!", q1: QuizQuestions(question: "What was the first home console game, in 1972?", answers: ["Pong", "Tetris", "Asteroids", "Magnavox Odyssey"], correct: 3), q2: QuizQuestions(question: "What was the average age of video game players in 2011?", answers: ["16", "23", "44", "34"], correct: 3), numCorrect: 0, done: false)]
    static var listOfQuizzesTest = [Quiz(image: UIImage(named: "soccer.jpeg"), title: "Soccer History", description: "Do you know your soccer history?", q1: QuizQuestions(question: "Which national team has won the most World Cups?", answers: ["Brazil", "Italy", "Germany", "France"], correct: 0), q2: QuizQuestions(question: "Which national team won the first World Cup in 1930?", answers: ["Brazil", "Uruguay", "Argentina", "England"], correct: 1), numCorrect: 0, done: false)]
    
    static func quizAdd(item: Quiz){
        listOfQuizzesTest.append(item)
    }
}

class ViewController: UIViewController, UITableViewDelegate {
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        tableView.dataSource = dataSource
        tableView.delegate = self
        QuizList.listOfQuizzesTest = []

        let jsonURL = "http://tednewardsandbox.site44.com/questions.json"
        guard let url = URL(string: jsonURL) else { return }
        URLSession.shared.dataTask(with: url) {
            (data, response, err) in
            // check err
            // print(err!)
            // do stuff here
            guard let data = data else { return }
            //let dataAsString = String(data: data, encoding: .utf8)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                for item in json! {
                    let title = item["title"] as! String
                    let desc = item["desc"] as! String
                    var text : String = ""
                    var answer : String = ""
                    var answers : [String] = []
                    if let questionsList = item["questions"] as? [[String:Any]] {
                        for questions in questionsList  {
                            text = questions["text"] as! String
                            answer = questions["answer"] as! String
                            answers = questions["answers"] as! [String]
                            print(text)
                            print(answer)
                            print(answers)
                        }
                    }
                    let a = Quiz(image: UIImage(named: "soccer.jpeg"), title: title, description: desc, q1: QuizQuestions(question: text, answers: answers, correct: Int32(answer)!), q2: QuizQuestions(question: text, answers: answers, correct: Int32(answer)!), numCorrect: 0, done: false)
                    QuizList.quizAdd(item: a)
                    print(title)
                    print(desc)
                    //arrJSON.append(item)
                }
            } catch {
                print(error)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }

            //let jsonString = String(data: json, encoding: .utf8)
        }.resume()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "segueGoToQuestion":
            //let source = segue.source as! ViewController
            let destination = segue.destination as! QuestionViewController
            destination.setIncoming(incoming: quizData!)
        default:
            NSLog("Unknown segue identifier -- " + segue.identifier!)
        }
    }
    var quizData : Quiz? = nil
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let section = indexPath.section
        let row = indexPath.row
        //let quizList = QuizList()
        quizData = QuizList.listOfQuizzesTest[row]
        NSLog((quizData?.q1.answers[0])!)
        performSegue(withIdentifier: "segueGoToQuestion", sender: self)
    }
    
    let dataSource = QuizDataSource(quizList: QuizList())
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func btnSettings(_ sender: Any) {
        let uiAlert = UIAlertController(title: "Sorry", message: "Check back for settings!", preferredStyle: .alert)
        uiAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(uiAlert, animated: true, completion: nil)
    }
    
}

class Quiz {
    var image: UIImage?
    var title: String
    var description: String
    var q1 : QuizQuestions
    var q2 : QuizQuestions
    var numCorrect : Int32
    var done : Bool
    
    init(image: UIImage?, title: String, description: String, q1: QuizQuestions, q2: QuizQuestions, numCorrect: Int32, done: Bool) {
        self.image = image
        self.title = title
        self.description = description
        self.q1 = q1
        self.q2 = q2
        self.numCorrect = numCorrect
        self.done = done
    }
}

class QuizDataSource : NSObject, UITableViewDataSource, UITableViewDelegate {
    init(quizList : QuizList) {
        self.quizList = quizList
    }
    
    
    let quizList : QuizList
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return QuizList.listOfQuizzesTest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewCell") as! ViewCell
    
        cell.lblTitle.text = QuizList.listOfQuizzesTest[indexPath.row].title
        cell.lblDescription.text = QuizList.listOfQuizzesTest[indexPath.row].description
        cell.imgView.image = QuizList.listOfQuizzesTest[indexPath.row].image
    
        return cell
    }
    
}

class QuizQuestions {
    var question : String
    var answers : [String]
    var correct : Int32
    
    init(question: String, answers: [String], correct: Int32) {
        self.question = question
        self.answers = answers
        self.correct = correct
    }
}

class ViewCell : UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
}


/*
 class ImportJSON {
 var title: String
 var desc: String
 var questions: Questions
 struct Questions {
 var text : String
 var answers : [String]
 var answer : Int32
 
 init(text: String, answers: [String], answer: Int32) {
 self.text = text
 self.answers = answers
 self.answer = answer
 }
 }
 init(title: String, desc: String, questions: Questions) {
 self.title = title
 self.desc = desc
 self.questions = questions
 }
 }
 */
