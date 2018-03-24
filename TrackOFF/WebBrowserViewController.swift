//
//  WebBrowserViewController.swift
//  TrackOFF
//
//  Created by Jal Irani on 3/23/18.
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSoup
import WebKit

class WebBrowserViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var urlTextfield: UITextField!
    
    // Default URL - Google homepage
    var url = URL(string: "https://www.google.com")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.urlTextfield.delegate = self
        urlTextfield.returnKeyType = .go
        urlTextfield.autocorrectionType = .no
        loadRequest()
        //getJS()
    }
    
    // To remove status bar if needed
    //override var prefersStatusBarHidden: Bool {
        //return true
    //}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.returnKeyType == UIReturnKeyType.go) {
            if verifyUrl(urlString: textField.text!) {
                url = URL(string: textField.text!)
                loadRequest()
            } else {
                // create popup
            }
            urlTextfield.resignFirstResponder()
        }
        return true
    }
    
    func loadRequest() {
        let request = URLRequest(url: url!)
        webView.load(request)
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
    
    func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = URL(string: urlString) {
                return UIApplication.shared.canOpenURL(url)
            }
        }
        return false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is JavaScriptParserViewController {
            let jsVC = segue.destination as? JavaScriptParserViewController
            if url?.absoluteString == "" {
                // Create alert if no URL
            } else {
                jsVC?.webUrl = url?.absoluteString
            }
        }
    }

}
