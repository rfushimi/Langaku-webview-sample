//
//  ViewController.swift
//  Langaku-webview-sample
//
//  Created by Ryohei Fushimi on 2022/01/27.
//

import UIKit
import WebKit

extension UIViewController {
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

class TutorialWebViewController: UIViewController, WKScriptMessageHandler {
    override func viewDidLoad() {
        let configuration = WKWebViewConfiguration()
        configuration.userContentController.add(self, name: "onComplete")

        let cookie = HTTPCookie(properties: [
            .domain: "localhost",
            .path: "/",
            .port: "8080",
            .name: "Cookie-Key",
            .value: "Cookie-Secret",
            .expires: NSDate(timeIntervalSinceNow: 3600*24*7)
//            .secure: "FALSE",
        ])!
        configuration.websiteDataStore.httpCookieStore.setCookie(cookie, completionHandler: nil)
        let webView = WKWebView(frame: .zero, configuration: configuration)

        // To ensure that WebView frame == parent view frame
        webView.frame = self.view.bounds
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Loading state
        // webView.backgroundColor = .green
        
        let loadLocalFile = false
        if (loadLocalFile) {
            // (1) To use a local HTML file.
            // let localHTMLFileURL = Bundle.main.url(forResource: "index", withExtension: "html")!
            // webView.loadFileURL(localHTMLFileURL, allowingReadAccessTo: localHTMLFileURL)
        } else {
            // (2) To use a remote server.
            // Try `ruby -run -e httpd . -p 8080` to run httpd on localhost:8080
            let remoteURL = URL(string: "http://localhost:8080")!
            let remoteURLRequest = URLRequest(url: remoteURL)
            webView.load(remoteURLRequest)
        }
                
        self.view.addSubview(webView)
        super.viewDidLoad()
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let body: String = message.body as! String
        print(message.body)
        let messageData: Data = body.data(using: String.Encoding.utf8)!
        let messageItems = try! JSONSerialization.jsonObject(with: messageData) as! Dictionary<String, Any>
        let nextActon = messageItems["next_action"] as! String
        switch (nextActon) {
        case "ComicViewer":
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyBoard.instantiateViewController(identifier: "ComicViewerViewController")
            self.present(controller, animated: true, completion: nil)
        case "Complete":
            self.dismiss(self)
        default:
            print("undefined")
        }
    }
}

class ComicViewerViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
    }
}
