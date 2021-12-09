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
    @IBOutlet weak var digitLabelStackView: UIStackView!
    
    @IBOutlet weak var option1Btn: UIButton!
    @IBOutlet weak var option2Btn: UIButton!
    @IBOutlet weak var option3Btn: UIButton!
    @IBOutlet weak var option4Btn: UIButton!
    @IBOutlet weak var optionBtnStackView: UIStackView!
    
    
    @IBOutlet weak var skipBtn: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var pauseBtn: UIButton!
    @IBOutlet weak var resetBtn: UIButton!
    
    @IBOutlet weak var resultCorrectAnswerlabel: UILabel!
    @IBOutlet weak var resultWrongAnswerlabel: UILabel!
    @IBOutlet weak var resultStackView: UIStackView!
    @IBOutlet weak var resultImageView: UIImageView!
    
    @IBOutlet weak var yourOnSumLabel: UILabel!
    
    @IBOutlet weak var answerLabel: UILabel!
    
    var currentQuestionNumber = 0
    var recordOfSum: [Sum?] = []
    
    var seconds = 0 //This variable will hold a starting value of seconds. It could be any amount above 0.
    var timer = Timer()
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    var resumeTapped = false
    var totalTimeLimitInSecond = 180
    var refreshSumAfterSecond = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        option1Btn.addTarget(self, action: #selector(onClickAnswerBtn(sender: )), for: UIControl.Event.touchUpInside)
        option2Btn.addTarget(self, action: #selector(onClickAnswerBtn(sender: )), for: UIControl.Event.touchUpInside)
        option3Btn.addTarget(self, action: #selector(onClickAnswerBtn(sender: )), for: UIControl.Event.touchUpInside)
        option4Btn.addTarget(self, action: #selector(onClickAnswerBtn(sender: )), for: UIControl.Event.touchUpInside)
        
        //skipBtn.addTarget(self, action: #selector(onClickSkipAnswerBtn(sender: )), for: UIControl.Event.touchUpInside)
        
        startBtn.addTarget(self, action: #selector(startButtonTapped(sender: )), for: UIControl.Event.touchUpInside)
        pauseBtn.addTarget(self, action: #selector(pauseButtonTapped(sender: )), for: UIControl.Event.touchUpInside)
        resetBtn.addTarget(self, action: #selector(restartButtonTapped(sender: )), for: UIControl.Event.touchUpInside)
        
        pauseBtn.isEnabled = false
        resultStackView.isHidden = true
        startButtonTapped(sender: startBtn)
        let firstSum = getNextQuestion(at: currentQuestionNumber)
//        digitLabelStackView.backgroundColor = .black
//        optionBtnStackView.backgroundColor = .black
        applyColor()
        setupDataOnUI(sum: firstSum)
    }
    
    func applyColor() {
        view.backgroundColor = .black

        label1.textColor = .white
        label2.textColor = .white
        label3.textColor = .white
        label4.textColor = .white
        
        option1Btn.setTitleColor(.white, for: UIControl.State.normal)
        option2Btn.setTitleColor(.white, for: UIControl.State.normal)
        option3Btn.setTitleColor(.white, for: UIControl.State.normal)
        option4Btn.setTitleColor(.white, for: UIControl.State.normal)
        
        timeLabel.textColor = .white
        startBtn.setTitleColor(.black, for: UIControl.State.normal)
        pauseBtn.setTitleColor(.black, for: UIControl.State.normal)
        resetBtn.setTitleColor(.black, for: UIControl.State.normal)
        
        resultCorrectAnswerlabel.textColor = .white
        resultWrongAnswerlabel.textColor = .white
        
        yourOnSumLabel.textColor = .white
        answerLabel.textColor = .white
        
        option1Btn.layer.borderColor = UIColor.green.cgColor
        option1Btn.layer.borderWidth = 2.0
        
        option2Btn.layer.borderColor = UIColor.green.cgColor
        option2Btn.layer.borderWidth = 2.0
        
        option3Btn.layer.borderColor = UIColor.green.cgColor
        option3Btn.layer.borderWidth = 2.0
        
        option4Btn.layer.borderColor = UIColor.green.cgColor
        option4Btn.layer.borderWidth = 2.0
        
//        label3.isHidden = true
//        label4.isHidden = true
    }
    
    func setupDataOnUI(sum: Sum?) {
        yourOnSumLabel.text = "Question No. \(sum?.id ?? 0):"
        if let firstSum =  sum, seconds <= totalTimeLimitInSecond {

            label1.text = "  \(firstSum.row1 ?? 0)"
            if let number = firstSum.row2, number >= 0 {
                label2.text = "+ \(number)"
            } else {
                label2.text = "- \(abs(firstSum.row2 ?? 0))"
            }
            
            if let number = firstSum.row3, number >= 0 {
                label3.text = "+ \(number)"
            } else {
                label3.text = "- \(abs(firstSum.row3 ?? 0))"
            }

            if let number = firstSum.row4, number >= 0 {
                label4.text = "+ \(number)"
            } else {
                label4.text = "- \(abs(firstSum.row4 ?? 0))"
            }



//            label3.text = "\(firstSum.row3 ?? 0)"
//            label4.text = "\(firstSum.row4 ?? 0)"

            option1Btn.setTitle("\(firstSum.option1 ?? 0)", for: .normal)
            option2Btn.setTitle("\(firstSum.option2 ?? 0)", for: .normal)
            option3Btn.setTitle("\(firstSum.option3 ?? 0)", for: .normal)
            option4Btn.setTitle("\(firstSum.option4 ?? 0)", for: .normal)
        } else {
            print("Thanks you for attempting")
            
//            if currentQuestionNumber == abacusRootModel.data?.sumes?.count ?? 0 {
            if seconds <= totalTimeLimitInSecond {
                
                print("You reached end")
                pauseButtonTapped(sender: pauseBtn)
                digitLabelStackView.isHidden = true
                optionBtnStackView.isHidden = true
                answerLabel.isHidden = true
                
                let skippedList = recordOfSum.filter { $0?.isSumSkipped == true}
                let wrongList = recordOfSum.filter { $0?.answer != $0?.userSelectedAnswer && $0?.isSumSkipped != true}
                let correctAnswerList = recordOfSum.filter { $0?.answer == $0?.userSelectedAnswer}
                print("Total Number of Skipped : \(skippedList.count)")
                print("Total Number of Wrong   : \(wrongList.count)")
                print("Total Number of correct : \(correctAnswerList.count)")
                
                print("Total attempted         : \(skippedList.count + wrongList.count + correctAnswerList.count)")
                var yourResult = [
                    "paperName" :  title,
                    "date": getTimeStampDateString(),
                    "totalTime" : timeLabel.text,
                    "correctAnswers" : correctAnswerList.count.description,
                    "wrongAnswers" : wrongList.count.description,
                    "currentDeviceTime" : getCurrentDeviceTime()
                ]
                let myOwnUserDefault = UserDefaults(suiteName: "AbacusRecords")
                myOwnUserDefault?.setValue(yourResult, forKey: getTimeStampDateStringForAsKey())
                myOwnUserDefault?.synchronize()
                print(yourResult)
                
                resultStackView.isHidden = false
                if 75 <= correctAnswerList.count &&  seconds <= 180 {
                    resultImageView.image = UIImage(named: "thumbsUp")
                } else {
                    resultImageView.image = UIImage(named: "thumbsDown")
                }
                resultCorrectAnswerlabel.text = "Your total correct answer: \(correctAnswerList.count.description)"
                resultWrongAnswerlabel.text = "Your total wrong answer: \(wrongList.count.description)"
//                currentQuestionNumber = 0
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
        if seconds <= totalTimeLimitInSecond {
            setupDataOnUI(sum: getNextQuestion(at: currentQuestionNumber))
        } else {
            setupDataOnUI(sum: nil)
        }
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
        resultStackView.isHidden = true
        digitLabelStackView.isHidden = false
        optionBtnStackView.isHidden = false
        answerLabel.isHidden = false
    }
    
    @objc func updateTimer() {
        seconds += refreshSumAfterSecond     //This will decrement(count down)the seconds.
        timeLabel.text = timeString(time: TimeInterval(seconds)) //"\(seconds)" //This will update the label.
        if totalTimeLimitInSecond <= seconds {
            setupDataOnUI(sum: nil)
        }
//        else {
//            onClickAnswerBtn(sender: UIButton())
//        }

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

