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
                createAlert(urlName: textField.text!)
            }
            urlTextfield.resignFirstResponder()
        }
        return true
    }
    
    func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = URL(string: urlString) {
                return UIApplication.shared.canOpenURL(url)
            }
        }
        return false
    }
    
    func loadRequest() {
        let request = URLRequest(url: url!)
        webView.load(request)
    }
    
    func createAlert(urlName: String) {
        let alert = UIAlertController(title: "Invalid URL", message: "\(urlName) is an invalid url", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is JavaScriptParserViewController {
            let jsVC = segue.destination as? JavaScriptParserViewController
            jsVC?.webUrl = url?.absoluteString
        }
    }
}
