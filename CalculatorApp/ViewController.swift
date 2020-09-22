//
//  ViewController.swift
//  CalculatorApp
//
//  Created by 高橋康之 on 2020/09/21.
//  Copyright © 2020 yasu.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    //セルのサイズ、コレクションビューのヘッダーのサイズを変更できる
UICollectionViewDelegateFlowLayout,
    //テーブルビュー
UITableViewDelegate,UITableViewDataSource {
    //セクションの数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numArray.count
    }
    //セルの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numArray.count
    }
    //セルのサイズ、コレクションビューのヘッダーのサイズを変更できる
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: collectionView.frame.width, height: 10)
    }
    //セルの大きさ変更
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //横の長さを4分割して設定
        let width = (collectionView.frame.width - 3 * 15) / 4
        return .init(width: width, height: width)
    }
    //隙間の調整
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    //セルに表示する内容
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = calculatorView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! CalculatorViewCell
        
        //numArrayの配列を反映
        cell.numLabel.text = numArray[indexPath.section][indexPath.row]
        //色変更
        numArray[indexPath.section][indexPath.row].forEach {(numberString) in
            if "0"..."9" ~= numberString ||  numberString.description == "." {cell.numLabel.backgroundColor = .darkGray
            } else if numberString == "C" || numberString == "+" || numberString == "=" {
                cell.numLabel.backgroundColor = .brown
                cell.numLabel.textColor = .black
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        print("aaa")
        //ボタン名を入力できる
        let number = numArray[indexPath.section][indexPath.row]
        
        if calculateStatus == .none{
            //        print(number)
            switch number {
            case "0"..."9":
                numLabel.text = number
            case "+":
                firstNum = numLabel.text ?? ""
                calculateStatus = .plus
               
            case "C" :
                clear()
                
            default:
                break
            }
        } else if calculateStatus == .plus {
            switch number {
            case "0"..."9":
                numLabel.text = number
            case "=":
                secondNum = numLabel.text ?? ""
                
                let firstNumber = Double(firstNum) ?? 0
                let secondNumber = Double(secondNum) ?? 0
                
                
                numLabel.text = String(firstNumber + secondNumber)
            case "C" :
                clear()
                
            default:
                break
            }
        }
        
    }
    
    func clear() {
        numLabel.text = "0"
        calculateStatus = .none
    }
    
    enum CalculateStatus {
        case none, plus
    }
    
    
    
    //ここからテーブルビュー
    //セクションの数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return costArray.count
    }
    //セルに表示する内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //"Cell"というIDのセルを何個用意するか決める(セルの生成)
        let cell = itemTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //表示内容を決める
        cell.textLabel?.text = "\(costArray[indexPath.row])"
        
        return cell
        
    }
    
    
    
    //受け皿
    //最初の値
    var firstNum = ""
    //2つ目の値
    var secondNum = ""
    
    var calculateStatus: CalculateStatus = .none
    //配列をどんどん入れるための空の配列
    var costArray:[Double] = []
    //costTaxをどんどん足していく値
    var totalCost:Double = 0
    //電卓のtextの配列
    let numArray = [
        
        ["7","8","9","登録"],
        ["4","5","6","C"],
        ["1","2","3","+"],
        ["0",".","BS","="],
        
    ]
    
    
    //紐付け
    //電卓
    @IBOutlet var calculatorView: UICollectionView!
    //計算式ラベル
    @IBOutlet var numLabel: UILabel!
    //電卓の高さ
    @IBOutlet var calculatorHight: NSLayoutConstraint!
    
    //確認画面
    @IBOutlet weak var itemTableView: UITableView!
    
    
    //最初の画面設定
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calculatorView.delegate = self
        calculatorView.dataSource = self
        calculatorView.register(CalculatorViewCell.self, forCellWithReuseIdentifier: "cellId")
        //電卓の高さ設定
        calculatorHight.constant = view.frame.width * 1.1
        
        calculatorView.backgroundColor = .white
        calculatorView.backgroundColor = .clear
        //
        //        calculatorView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        
        itemTableView.delegate = self
        itemTableView.dataSource = self
        
        view.backgroundColor = .black
        
    }
    
    
    
    
}


class CalculatorViewCell: UICollectionViewCell {
    //電卓の見た目の編集
    let numLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .white
        //テキストの配置
        label.textAlignment = .center
        label.text = "1"
        label.font = .boldSystemFont(ofSize: 30)
        //範囲を中か外か
        label.clipsToBounds = true
        label.backgroundColor = .orange
        return label
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(numLabel)
        //セルの大きさと同じに
        numLabel.frame.size = self.frame.size
        //丸くする
        numLabel.layer.cornerRadius = self.frame.height / 2
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
