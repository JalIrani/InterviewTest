//
//  JavaScriptParserViewController.swift
//  TrackOFF
//
//  Created by Jal Irani on 3/23/18.
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit

class JavaScriptParserViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        getJS()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getJS() {
        var embeddedCount = 0
        var externalCount = 0
        var externalFilePaths:[String] = []
        let url = "http://www.trackoff.com"
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
            print("There are \(embeddedCount) embedded JavaScript 'files' and \(externalCount) external JavaScript Files in the webpage \(url)")
            if externalFilePaths.count > 0 {
                print("--- File Paths ---")
                for filePath in externalFilePaths {
                    print(filePath)
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
