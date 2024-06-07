import UIKit
import WebKit

class ReciteViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Lets Recite"
        view.backgroundColor = .systemGreen
        
        // Initialize and configure the WKWebView
        webView = WKWebView(frame: self.view.frame)
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        // Load the web app URL
        if let url = URL(string: "https://letsrecite.netlify.app") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        // Optional: Add constraints to support different screen sizes
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
