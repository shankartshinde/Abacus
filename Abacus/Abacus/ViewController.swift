//
//  ViewController.swift
//  Abacus
//
//  Created by AyunaLabs on 28/11/21.
//

import UIKit

class PracticeViewController: UIViewController {
    
    var abacusRootModel = AbacusRoot(data: nil)
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    
    
    @IBOutlet weak var option1Btn: UIButton!
    @IBOutlet weak var option2Btn: UIButton!
    @IBOutlet weak var option3Btn: UIButton!
    @IBOutlet weak var option4Btn: UIButton!
    
    
    @IBOutlet weak var skipBtn: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var pauseBtn: UIButton!
    @IBOutlet weak var resetBtn: UIButton!
    
    var currentQuestionNumber = 0
    var recordOfSum: [Sum?] = []
    
    var seconds = 0 //This variable will hold a starting value of seconds. It could be any amount above 0.
    var timer = Timer()
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    var resumeTapped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        do {
            let dataFromJSONResponse = Data(paper1JSON.utf8)
            abacusRootModel = try JSONDecoder().decode(AbacusRoot.self, from: dataFromJSONResponse)
            print(abacusRootModel)
        } catch {
            print("Error while JSON encoding : \(error)")
        }
        
        option1Btn.addTarget(self, action: #selector(onClickAnswerBtn(sender: )), for: UIControl.Event.touchUpInside)
        option2Btn.addTarget(self, action: #selector(onClickAnswerBtn(sender: )), for: UIControl.Event.touchUpInside)
        option3Btn.addTarget(self, action: #selector(onClickAnswerBtn(sender: )), for: UIControl.Event.touchUpInside)
        option4Btn.addTarget(self, action: #selector(onClickAnswerBtn(sender: )), for: UIControl.Event.touchUpInside)
        
        skipBtn.addTarget(self, action: #selector(onClickSkipAnswerBtn(sender: )), for: UIControl.Event.touchUpInside)
        
        startBtn.addTarget(self, action: #selector(startButtonTapped(sender: )), for: UIControl.Event.touchUpInside)
        pauseBtn.addTarget(self, action: #selector(pauseButtonTapped(sender: )), for: UIControl.Event.touchUpInside)
        resetBtn.addTarget(self, action: #selector(restartButtonTapped(sender: )), for: UIControl.Event.touchUpInside)
        
        pauseBtn.isEnabled = false
        
        let firstSum = getNextQuestion(at: currentQuestionNumber)
        setupDataOnUI(sum: firstSum)
    }
    
    func setupDataOnUI(sum: Sum?) {
        if let firstSum =  sum {
//            label1.text = "\(firstSum.question?.row1 ?? 0)"
//            label2.text = "\(firstSum.question?.row2 ?? 0)"
//            label3.text = "\(firstSum.question?.row3 ?? 0)"
//            label4.text = "\(firstSum.question?.row4 ?? 0)"

            label1.text = "\(firstSum.row1 ?? 0)"
            label2.text = "\(firstSum.row2 ?? 0)"
            label3.text = "\(firstSum.row3 ?? 0)"
            label4.text = "\(firstSum.row4 ?? 0)"

            option1Btn.setTitle("\(firstSum.option1 ?? 0)", for: .normal)
            option2Btn.setTitle("\(firstSum.option2 ?? 0)", for: .normal)
            option3Btn.setTitle("\(firstSum.option3 ?? 0)", for: .normal)
            option4Btn.setTitle("\(firstSum.option4 ?? 0)", for: .normal)
        } else {
            print("Thanks you for attempting")
            
            if currentQuestionNumber == abacusRootModel.data?.sumes?.count ?? 0 {
                print("You reached end")
                
                let skippedList = recordOfSum.filter { $0?.isSumSkipped == true}
                let wrongList = recordOfSum.filter { $0?.answer != $0?.userSelectedAnswer && $0?.isSumSkipped != true}
                let correctAnswerList = recordOfSum.filter { $0?.answer == $0?.userSelectedAnswer}
                print("Total Number of Skipped : \(skippedList.count)")
                print("Total Number of Wrong   : \(wrongList.count)")
                print("Total Number of correct : \(correctAnswerList.count)")
                
                print("Total attempted         : \(skippedList.count + wrongList.count + correctAnswerList.count)")
                currentQuestionNumber = 0
            }
            
        }
    }
    
    @objc func onClickAnswerBtn(sender: UIButton) {
        let candidateSelectedValue = Int(sender.titleLabel?.text ?? "-1")
        var sum = getNextQuestion(at: currentQuestionNumber)
        sum?.userSelectedAnswer = candidateSelectedValue
        
        if candidateSelectedValue == sum?.answer {
            sum?.isSumCorrect = true
        } else {
            sum?.isSumCorrect = false
        }
        recordOfSum.append(sum)
        currentQuestionNumber += 1
        setupDataOnUI(sum: getNextQuestion(at: currentQuestionNumber))
    }
    
    @objc func onClickSkipAnswerBtn(sender: UIButton) {
        var sum = getNextQuestion(at: currentQuestionNumber)
        sum?.isSumSkipped = true
        recordOfSum.append(sum)
        currentQuestionNumber += 1
        setupDataOnUI(sum: getNextQuestion(at: currentQuestionNumber))
    }
    
    func getNextQuestion(at index: Int) -> Sum? {
        if index < abacusRootModel.data?.sumes?.count ?? 0 {
            return abacusRootModel.data?.sumes?[index]
        }
        return nil
    }
}

extension PracticeViewController {
    @objc func startButtonTapped(sender: UIButton) {
        if !isTimerRunning {
            runTimer()
            startBtn.isEnabled = false
        }
    }
    
    @objc func pauseButtonTapped(sender: UIButton) {
        if self.resumeTapped == false {
            timer.invalidate()
            self.resumeTapped = true
            pauseBtn.setTitle("Resume", for: UIControl.State.normal)
        } else {
            runTimer()
            self.resumeTapped = false
            pauseBtn.setTitle("Pause", for: UIControl.State.normal)
        }
    }
    
    @objc func restartButtonTapped(sender: UIButton) {
        timer.invalidate()
        seconds = 0    //Here we manually enter the restarting point for the seconds, but it would be wiser to make this a variable or constant.
        timeLabel.text = timeString(time: TimeInterval(seconds))
        isTimerRunning = false
        pauseBtn.isEnabled = false
    }
    
    @objc func updateTimer() {
        seconds += 1     //This will decrement(count down)the seconds.
        timeLabel.text = timeString(time: TimeInterval(seconds)) //"\(seconds)" //This will update the label.
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(PracticeViewController.updateTimer)), userInfo: nil, repeats: true)
        isTimerRunning = true
        pauseBtn.isEnabled = true
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        //return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
        return String(format:"%02i:%02i", minutes, seconds)
    }
}

