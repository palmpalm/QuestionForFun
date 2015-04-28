//
//  ViewController.swift
//  Quiz
//
//  Created by IST-MAC-17 on 4/23/2558 BE.
//  Copyright (c) 2558 ist.mut. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    private var urlJson:NSURL = NSURL(fileURLWithPath: "http://palmpalm.ist-performance.com/quiz/public/game")!;
    private var quizId:UInt32 = 0;
    private var questionId = 0;
    private var questionNum = 1;
    private var score = 0;
    private let maxQuestion = 10;

    @IBOutlet weak var viewQuestion: UIWebView!
   
    
    @IBOutlet weak var choice1: UIButton!
    @IBAction func choiceFirst(sender: AnyObject) {
        onClickAnswer(1);
    }
    
    @IBOutlet weak var choice2: UIButton!
    @IBAction func choiceSecond(sender: AnyObject) {
        onClickAnswer(2);
    }
    
    @IBOutlet weak var choice3: UIButton!
    @IBAction func choiceThird(sender: AnyObject) {
        onClickAnswer(3);
    }
    
    @IBOutlet weak var choice4: UIButton!
    @IBAction func choiceForth(sender: AnyObject) {
        onClickAnswer(4);
    }
    
    @IBOutlet weak var Score: UILabel!
    @IBOutlet weak var Question: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        newGame();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func newGame() {
        // self.quizId = randRange(1, upper: 10);
        self.quizId = 1;
        self.questionId = 0;
        self.questionNum = 1;
        self.score = 0;
        
        self.Question.text = "\(self.questionNum) / 10";
        self.Score.text = "\(self.score)";
        
        onLoadQuestion();
    }
    
    func onClickAnswer(choiceNum:Int) {
        var flag = 0;
        self.urlJson = NSURL(string: "http://palmpalm.ist-performance.com/quiz/public/game?mode=answer&questionId=\(questionId)&answerId=\(choiceNum)")!;

        // 1
        let url = self.urlJson
        let urlSession = NSURLSession.sharedSession()
        // 2
        let jsonQuery = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
            if (error != nil) {
                println(error.localizedDescription);
            }
            var err: NSError?;
            // 3
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
            if (err != nil) {
                println("JSON Error \(err!.localizedDescription)")
            }
            // 4
            let answer = jsonResult.valueForKey("answer") as Bool;
            
            dispatch_async(dispatch_get_main_queue(), {
                if (answer) {
                    self.score++;
                }
                if (flag == 0) {
                    flag++;
                    self.questionNum++;
                    
                    if (self.questionNum <= self.maxQuestion) {
                        self.onLoadQuestion();
                    } else {
                        self.gameOver();
                        self.newGame();
                    }
                }
                
            });
        })
        // 5
        jsonQuery.resume();
    }
    
    func onLoadQuestion() {
        self.Question.text = "\(self.questionNum) / 10";
        self.Score.text = "\(self.score)";
        
        self.urlJson = NSURL(string: "http://palmpalm.ist-performance.com/quiz/public/game?mode=quiz&quizId=\(quizId)&sequence=\(questionNum)")!;
        
        // 1
        let url = self.urlJson
        let urlSession = NSURLSession.sharedSession()
        //2
        let jsonQuery = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
            if (error != nil) {
                println(error.localizedDescription)
            }
            var err: NSError?
            // 3
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary;
            
            if (err != nil) {
                println("JSON Error \(err!.localizedDescription)")
            }
            
            println("Data items count: \(jsonResult.count)")
            
            for item in jsonResult {
                // loop through data items
                println(item);
            }
            
            // 4
            // let jsonDate: String! = jsonResult["date"] as NSString
            let id: String! = jsonResult.valueForKey("id")! as String;
            var q: String! = jsonResult.valueForKey("q")! as String;
            let c1: String! = jsonResult.valueForKey("c1")! as String;
            let c2: String! = jsonResult.valueForKey("c2")! as String;
            let c3: String! = jsonResult.valueForKey("c3")! as String;
            let c4: String! = jsonResult.valueForKey("c4")! as String;
            
            dispatch_async(dispatch_get_main_queue(), {
                self.questionId = id.toInt()!;
                
                // 
                q = "<body bgcolor='#5f5f77'>\(q)</body>";
                
                self.viewQuestion.loadHTMLString(q!, baseURL: nil);
                self.choice1.setTitle(c1, forState: UIControlState.Normal);
                self.choice2.setTitle(c2, forState: UIControlState.Normal);
                self.choice3.setTitle(c3, forState: UIControlState.Normal);
                self.choice4.setTitle(c4, forState: UIControlState.Normal);
            });
        });
        // 5
        jsonQuery.resume();
    }
    
    func gameOver() {
        var alertView = UIAlertView();
        alertView.addButtonWithTitle("New Game");
        if(score <= 5){
        alertView.title = "Finished WoW Very Noob";
        }else{
            alertView.title = "Finished Very Good";
        }
        alertView.message = "Score: \(self.score) / 10";
        alertView.show();
    }
    
    @IBAction func NEWGAME(sender: UIButton) {
        self.newGame();
    }
    

   /* func randRange (lower: UInt32 , upper: UInt32) -> UInt32 {
        return lower + arc4random_uniform(upper - lower + 1)
    }*/

}

