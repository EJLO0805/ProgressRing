//
//  ViewController.swift
//  ProgressRing
//
//  Created by 羅以捷 on 2022/7/19.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        circleGray()
        showGoalMoneyIndex.text = "你已經存了\(goalMoneyIndex)次第一桶金"
    }
    var totalMoney: Double = 0
    let goalMoney : Double = 1000000
    var goalMoneyIndex = 0
    var formatter = NumberFormatter()
    //製作一個灰色底的圓環
    func circleGray() {
        let circleBackground = UIBezierPath(arcCenter: circleView.center, radius: 80, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        let circleBackgroundLayer = CAShapeLayer()
        circleBackgroundLayer.path = circleBackground.cgPath
        circleBackgroundLayer.fillColor = UIColor.clear.cgColor
        circleBackgroundLayer.lineWidth = 10
        circleBackgroundLayer.strokeColor = UIColor.gray.cgColor
        view.layer.addSublayer(circleBackgroundLayer)
    }
    //存錢的進度圖
    func saveMoney() {
        formatter.maximumFractionDigits = 2
        formatter.roundingMode = NumberFormatter.RoundingMode.floor
        goalMoneyIndex = Int(totalMoney/goalMoney)
        let circleMoney = totalMoney - goalMoney * Double(goalMoneyIndex)
        var percentageGoal = circleMoney/goalMoney
        if Int(circleMoney)%Int(goalMoney) == 0 {
            percentageGoal = 1
        }
        let degreeIn = CGFloat(percentageGoal)
        let startDegree : CGFloat = 270/180*CGFloat.pi
        let percentPath = UIBezierPath(arcCenter: circleView.center, radius: 80, startAngle: startDegree, endAngle: startDegree+degreeIn*2*CGFloat.pi, clockwise: true)
        let percentLayer = CAShapeLayer()
        percentLayer.path = percentPath.cgPath
        percentLayer.lineWidth = 10
        percentLayer.strokeColor = UIColor.blue.cgColor
        percentLayer.fillColor = UIColor.clear.cgColor
        percentLayer.lineCap = CAShapeLayerLineCap.round
        view.layer.addSublayer(percentLayer)
        showPercent.text = String(format: "%.1f", percentageGoal*100) + "%"
        moneyInput.text = ""
        showGoalMoneyIndex.text = "你已經存了\(goalMoneyIndex)次第一桶金"
        showResult.text = "恭喜你存款有" + formatter.string(for: totalMoney/10000)! + "萬元，距離下一個第一桶金還有" + formatter.string(for: (goalMoney-circleMoney)/10000)! + "萬元"
    }
    func lostMoney () {
        formatter.maximumFractionDigits = 2
        formatter.roundingMode = NumberFormatter.RoundingMode.floor
        goalMoneyIndex = Int(totalMoney/goalMoney)
        let percentageGoal = totalMoney/goalMoney
        let degreeIn = CGFloat(percentageGoal)
        let startDegree : CGFloat = 270/180*CGFloat.pi
        let percentPath = UIBezierPath(arcCenter: circleView.center, radius: 80, startAngle: startDegree, endAngle: startDegree+degreeIn*2*CGFloat.pi, clockwise: false)
        let percentLayer = CAShapeLayer()
        percentLayer.path = percentPath.cgPath
        percentLayer.lineWidth = 10
        percentLayer.strokeColor = UIColor.red.cgColor
        percentLayer.fillColor = UIColor.clear.cgColor
        percentLayer.lineCap = CAShapeLayerLineCap.round
        view.layer.addSublayer(percentLayer)
        showPercent.text = String(format: "%.1f", percentageGoal*100) + "%"
        showGoalMoneyIndex.text = "你已經損失了\(-goalMoneyIndex)次第一桶金"
        showResult.text = "很遺憾的您目前負債中，您的債務還有" + formatter.string(for: -totalMoney/10000)! + "萬元，距離第一桶金還有" + formatter.string(for: (goalMoney-totalMoney)/10000)! + "萬元"
        moneyInput.text = ""
    }
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var moneyInput: UITextField!
    @IBOutlet weak var showPercent: UILabel!
    @IBOutlet weak var showResult: UILabel!
    @IBOutlet weak var showGoalMoneyIndex: UILabel!
    @IBAction func enterPercent(_ sender: Any) {
        let moneyIncome = Double(moneyInput.text!)
        if moneyIncome != nil {
            totalMoney = totalMoney + moneyIncome!
            if totalMoney >= 0 {
                circleGray()
                saveMoney()
            } else if totalMoney < 0{
                circleGray()
                lostMoney()
            }
        } else {
            showPercent.text = "ERROR"
            moneyInput.text = ""
        }
    }
    //全部重新計算
    @IBAction func clearAllresult(_ sender: Any) {
        totalMoney = 0
        circleGray()
        showResult.text = "重新開始存錢"
        goalMoneyIndex = 0
        showGoalMoneyIndex.text = "你已經存了\(goalMoneyIndex)次第一桶金"
        showPercent.text = "0.0%"
    }
    @IBAction func closePad(_ sender: Any) {
        view.endEditing(true)
    }
}
