//
//  ViewController.swift
//  SunriseApp
//
//  Created by yuwa on 2018/06/08.
//  Copyright © 2018年 yuwa. All rights reserved.
//

import UIKit

/*****************************************************
 クラス名：ViewController
 概要：日の出時刻検索画面コントローラクラス
 *****************************************************/
class ViewController: UIViewController {
    // 都市名
    @IBOutlet weak var cityNameInput: UITextField!
    // 日の出時刻
    @IBOutlet weak var sunriseTimeLabel: UILabel!
    
    //////////////////////////////////////////////////////
    // 画面ロード時の処理
    //////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    //////////////////////////////////////////////////////
    // メモリエラー時の処理
    //////////////////////////////////////////////////////
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //////////////////////////////////////////////////////
    // 調べるボタン押下時の処理
    //////////////////////////////////////////////////////
    @IBAction func findSurrise(_ sender: Any) {
        let url = "https://query.yahooapis.com/v1/public/yql?q=select%20astronomy.sunrise%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22\(cityNameInput.text!)%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"
        
        getURL(url: url)
    }
    
    //////////////////////////////////////////////////////
    // URL呼び出し処理
    //////////////////////////////////////////////////////
    func getURL(url:String) {
        do {
            // サーバからデータを取得
            let apiURL = URL(string: url)!
            let data = try Data(contentsOf: apiURL)
            // JSONをパース
            let json = try JSONSerialization.jsonObject(with: data) as! [String:Any]
            print(json)
            let query = json["query"] as! [String:Any]
            let results = query["results"] as! [String:Any]
            let channel = results["channel"] as! [String:Any]
            let astronomy = channel["astronomy"] as! [String:Any]
            
            // 取得した時刻を表示
            self.sunriseTimeLabel.text = "日の出時刻：　\(astronomy["sunrise"]!)"
        
        } catch {
            // 標準ではiPhoneから外部への通信は許可されていないので、権限を与える必要がある
            self.sunriseTimeLabel.text = "サーバーに接続できません"
        }
    }
}

