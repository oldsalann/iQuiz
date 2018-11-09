//
//  ViewController.swift
//  iquiz
//
//  Created by Nicholas Olds on 10/30/18.
//  Copyright © 2018 Nicholas Olds. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.dataSource = dataSource
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        let quizList : QuizList
        var quizData : Quiz
        if section == 0 {
            quizData = quizList.soccer[row]
        } else if section == 1 {
            quizData = quizList.basketball[row]
        } else if (section == 2) {
            quizData = quizList.videogames[row]
        }
        let uiAlert = UIAlertController(title: "You selected", message: name, preferredStyle: .alert)
        uiAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(uiAlert, animated: true, completion: nil)
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
    var answers : [String]
    var correct : Int32
    
    init(image: UIImage?, title: String, description: String, answers: [String], correct: Int32) {
        self.image = image
        self.title = title
        self.description = description
        self.answers = answers
        self.correct = correct
    }
}

class QuizList : UIViewController {
    var soccer = [Quiz(image: UIImage(named: "soccer.jpeg"), title: "What soccer player are you?", description: "Find out which player you are.", answers: ["1", "2", "3", "4"], correct: 1),
                  Quiz(image: UIImage(named: "soccer.jpeg"), title: "Do you know your teams?", description: "Test your knowledge!", answers: ["1", "2", "3", "4"], correct: 1)]
    var basketball = [Quiz(image: UIImage(named: "basket.jpg"), title: "What basketball player are you?", description: "Find out which player you are.", answers: ["1", "2", "3", "4"], correct: 1),
                      Quiz(image: UIImage(named: "basket.jpg"), title: "Do you know your teams?", description: "Test your knowledge!", answers: ["1", "2", "3", "4"], correct: 1)]
    var videogames = [Quiz(image: UIImage(named: "video.jpeg"), title: "Which videogame character are you?", description: "Find out which player you are.", answers: ["1", "2", "3", "4"], correct: 1),
                      Quiz(image: UIImage(named: "video.jpeg"), title: "Do you know your videogames?", description: "Test your gaming knowledge!", answers: ["1", "2", "3", "4"], correct: 1)]
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

class ViewCell : UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
}

class QuizDataSource : NSObject, UITableViewDataSource, UITableViewDelegate {
    init(quizList : QuizList) {
        self.quizList = quizList
    }
    
    let quizList : QuizList
    
    func numberOfSections(in tableView: UITableView) -> Int {return 3}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return quizList.soccer.count
        }
        else if section == 1 {
            return quizList.basketball.count
        }
        else if section == 2 {
            return quizList.videogames.count
        }
        else {
            assert(false, "3 Sections Only")
        }
    }
    
    // section headers
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Soccer"
        }
        else if section == 1 {
            return "Basketball"
        }
        else if section == 2 {
            return "Videogames"
        }
        else {
            assert(false, "3 Sections Only")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewCell") as! ViewCell
        
        if indexPath.section == 0 {
            cell.lblTitle.text = quizList.soccer[indexPath.row].title
            cell.lblDescription.text = quizList.soccer[indexPath.row].description
            cell.imgView.image = quizList.soccer[indexPath.row].image
        }
        else if indexPath.section == 1 {
            cell.lblTitle.text = quizList.basketball[indexPath.row].title
            cell.lblDescription.text = quizList.basketball[indexPath.row].description
            cell.imgView.image = quizList.basketball[indexPath.row].image
        }
        else if indexPath.section == 2 {
            cell.lblTitle.text = quizList.videogames[indexPath.row].title
            cell.lblDescription.text = quizList.videogames[indexPath.row].description
            cell.imgView.image = quizList.videogames[indexPath.row].image
        }
        else {
            assert(false, "Not valid: \(indexPath.section)")
        }
        
        return cell
    }
    
}

