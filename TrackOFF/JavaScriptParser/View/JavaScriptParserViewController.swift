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

// akjrebgiuabegiujqbrgijbqrgijbqergijbqekjgrbqekjgbqejkrgbkjaergbkjqebk

class JavaScriptParserViewController: UIViewController {
    
    // Display label
    @IBOutlet weak var jsDisplayLabel: UILabel!
    
    // Global URL var passed from WebBrowserVC
    var webUrl:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Obtain JS Analysis everytime the view is loaded
        getJS(url: webUrl!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Helper function to Count JS
    func getJS(url: String) {
        // Since page loads, initalize with zero JS file count
        var embeddedCount = 0
        var externalCount = 0
        var externalFilePaths:[String] = []
        
        // Request loaded URL to look for JS
        Alamofire.request(url).responseString { response in
            guard let html = response.result.value else { return }
            guard let els: Elements = try? SwiftSoup.parse(html).select("script") else { return }
            for element: Element in els.array() {
                guard let scriptPath = try? element.attr("src") else { return }
                
                // If missing the src=.. attribute, consider it embedded JS
                if scriptPath == "" {
                    embeddedCount += 1
                } else {
                    externalCount += 1
                    externalFilePaths.append(scriptPath)
                }
            }
            self.jsDisplayLabel.text = "There are: \(embeddedCount) embedded JavaScript 'file(s)' and \(externalCount) external JavaScript file(s) in the url: \n \(url)"
            
            // File paths to external JS (not in project, logs in console)
            if externalFilePaths.count > 0 {
                print("--- File Paths ---")
                for filePath in externalFilePaths {
                    print(filePath)
                }
            }
        }
    }
}
