//
//  JavaScriptParserViewController.swift
//  TrackOFF
//
//  Created by Jal Irani on 3/23/18.
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSoup

class JavaScriptParserViewController: UIViewController {
    
    @IBOutlet weak var jsDisplayLabel: UILabel!
    
    var webUrl:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getJS(url: webUrl!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getJS(url: String) {
        var embeddedCount = 0
        var externalCount = 0
        var externalFilePaths:[String] = []
        print(url)
        Alamofire.request(url).responseString { response in
            guard let html = response.result.value else { return }
            guard let els: Elements = try? SwiftSoup.parse(html).select("script") else { return }
            for element: Element in els.array() {
                guard let scriptPath = try? element.attr("src") else { return }
                
                if scriptPath == "" {
                    embeddedCount += 1
                } else {
                    externalCount += 1
                    externalFilePaths.append(scriptPath)
                }
            }
            self.jsDisplayLabel.text = "There are: \(embeddedCount) embedded JavaScript 'file(s)' and \(externalCount) external JavaScript file(s) in the url: \n \(url)"
            if externalFilePaths.count > 0 {
                print("--- File Paths ---")
                for filePath in externalFilePaths {
                    print(filePath)
                }
            }
        }
    }
}
