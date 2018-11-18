//
//  ViewController.swift
//  iquiz
//
//  Created by Nicholas Olds on 10/30/18.
//  Copyright © 2018 Nicholas Olds. All rights reserved.
//

import UIKit
import Reachability

class ViewController: UIViewController, UITableViewDelegate {
    let reachability = Reachability()!
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        tableView.dataSource = dataSource
        tableView.delegate = self
        QuizList.listOfQuizzesTest = []

        switch reachability.connection {
            case .wifi:
                print("Reachable via WiFi")
                getJSON()
            case .cellular:
                print("Reachable via Cellular")
                getJSON()
            case .none:
                print("Not Reachable")
                getLocal()
        }

    }
    override func viewDidAppear(_ animated: Bool) {
        switch reachability.connection {
        case .wifi:
            print("On WiFi")
        case .cellular:
            print("Reachable via Cellular")
        case .none:
            let uiAlert = UIAlertController(title: "Warning!", message: "You are currently not connected to the internet.", preferredStyle: .alert)
            uiAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(uiAlert, animated: true, completion: nil)
        }
    }
    func getLocal() {
        do {
            if let data = UserDefaults.standard.data(forKey: "jsonData") {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                for item in json! {
                    let title = item["title"] as! String
                    let desc = item["desc"] as! String
                    var text : String = ""
                    var answer : String = ""
                    var answers : [String] = []
                    var qs = [QuizQuestions]()
                    if let questionsList = item["questions"] as? [[String:Any]] {
                        for questions in questionsList  {
                            text = questions["text"] as! String
                            answer = questions["answer"] as! String
                            answers = questions["answers"] as! [String]
                            let q = QuizQuestions(question: text, answers: answers, correct: (Int32(answer)! - 1))
                            qs.append(q)
                        }
                    }
                    let a = Quiz(image: UIImage(named: "soccer.jpeg"), title: title, description: desc, qs: qs, numCorrect: 0, done: false, curQ: 0)
                    QuizList.quizAdd(item: a)
                    
                }
            }
        } catch {
            print(error)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func getJSON() {
        let jsonURL = "http://tednewardsandbox.site44.com/questions.json"
        guard let url = URL(string: jsonURL) else { return }
        URLSession.shared.dataTask(with: url) {
            (data, response, err) in
            // check err
            // print(err!)
            // do stuff here
            guard let data = data else { return }
            
            UserDefaults.standard.set(data , forKey: "jsonData")
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                for item in json! {
                    let title = item["title"] as! String
                    let desc = item["desc"] as! String
                    var text : String = ""
                    var answer : String = ""
                    var answers : [String] = []
                    var qs = [QuizQuestions]()
                    if let questionsList = item["questions"] as? [[String:Any]] {
                        for questions in questionsList  {
                            text = questions["text"] as! String
                            answer = questions["answer"] as! String
                            answers = questions["answers"] as! [String]
                            let q = QuizQuestions(question: text, answers: answers, correct: (Int32(answer)! - 1))
                            qs.append(q)
                        }
                    }
                    let a = Quiz(image: UIImage(named: "soccer.jpeg"), title: title, description: desc, qs: qs, numCorrect: 0, done: false, curQ: 0)
                    QuizList.quizAdd(item: a)
                    
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
        quizData = QuizList.listOfQuizzesTest[row]
        performSegue(withIdentifier: "segueGoToQuestion", sender: self)
    }
    
    let dataSource = QuizDataSource(quizList: QuizList())
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func btnSettings(_ sender: Any) {
        let uiAlert = UIAlertController(title: "Settings", message: "Check for updated quizzes!", preferredStyle: .alert)
        uiAlert.addAction(UIAlertAction(title: "Check Now", style: .default, handler: checkJSON))
        uiAlert.addAction(UIAlertAction(title: "Exit", style: .default, handler: nil))
        self.present(uiAlert, animated: true, completion: nil)
    }
    func checkJSON(alertAction: UIAlertAction) {
        QuizList.listOfQuizzesTest = []
        
        print("Checking and downloading new JSON")
        getJSON()
    }
}

// Classes and Structs

class Quiz {
    var image: UIImage?
    var title: String
    var description: String
    var qs : [QuizQuestions]
    var numCorrect : Int32
    var done : Bool
    var curQ : Int32
    
    init(image: UIImage?, title: String, description: String, qs: [QuizQuestions], numCorrect: Int32, done: Bool, curQ: Int32) {
        self.image = image
        self.title = title
        self.description = description
        self.qs = qs
        self.numCorrect = numCorrect
        self.done = done
        self.curQ = curQ
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


struct QuizList {
    static var listOfQuizzesTest = [Quiz]()
    
    static func quizAdd(item: Quiz){
        listOfQuizzesTest.append(item)
    }
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
