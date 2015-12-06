//
//  LoginViewController.swift
//  SwifToks
//
//  Created by Pivotal Dev Floater 70 on 2015-12-05.
//  Copyright © 2015 misa. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK - UIWebViewDelegate methods
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
    
        let range = request.URL?.absoluteString.rangeOfString("access_token")
        if ((range?.isEmpty) != nil) {
            NetworkClient.sharedInstance.handleInstagramRedirect(request.URL!)
            return false;
        }
        return true;
    }
    
    // MARK - IBActions
    @IBAction func loginButtonTapped(sender: AnyObject) {
        self.connectToInstagram()
    }
    
    // MARK - Helpers
    func connectToInstagram() {
        let request:NSURLRequest = NSURLRequest(URL: NetworkClient.sharedInstance.instagramAuthURL())
        webView.loadRequest(request)
        webView.hidden = false;
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
