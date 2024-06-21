import WebKit
import UIKit

class ReciteViewController: UIViewController, WKNavigationDelegate, UIDocumentInteractionControllerDelegate {
    var webView: WKWebView!
    var documentController: UIDocumentInteractionController?

    override func viewDidLoad() {
        super.viewDidLoad()

        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self

        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        if let url = URL(string: "https://931c-188-192-84-153.ngrok-free.app") {
            let request = URLRequest(url: url)
            webView.load(request)
        }

        setupMessageHandlers()
    }

    func setupMessageHandlers() {
        webView.configuration.userContentController.add(self, name: "download")
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if let response = navigationResponse.response as? HTTPURLResponse,
           response.statusCode == 200,
           let url = response.url {
            let downloadTask = URLSession.shared.downloadTask(with: url) { localURL, response, error in
                if let localURL = localURL {
                    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)

                    do {
                        if FileManager.default.fileExists(atPath: destinationURL.path) {
                            try FileManager.default.removeItem(at: destinationURL)
                        }
                        try FileManager.default.moveItem(at: localURL, to: destinationURL)
                        // Present alert only when the download button is clicked
                    } catch {
                        print("File move error: \(error)")
                    }
                }
            }
            downloadTask.resume()
        }
        decisionHandler(.allow)
    }

    func presentFileSavedAlert(filePath: URL, actionHandler: @escaping (String) -> Void) {
        let alert = UIAlertController(title: "File Saved", message: "Your file has been saved successfully. Would you like to view or share it now?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "View", style: .default, handler: { _ in
            actionHandler("View")
            self.previewFile(at: filePath)
        }))
        alert.addAction(UIAlertAction(title: "Share", style: .default, handler: { _ in
            actionHandler("Share")
            self.presentShareDialog(fileURL: filePath)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func previewFile(at filePath: URL) {
        documentController = UIDocumentInteractionController(url: filePath)
        documentController?.delegate = self
        documentController?.presentPreview(animated: true)
    }

    func presentShareDialog(fileURL: URL) {
        let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
}

extension ReciteViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "download", let body = message.body as? [String: String], let filename = body["filename"], let base64String = body["data"] {
            saveFile(base64String: base64String, fileName: filename)
        }
    }

    func saveFile(base64String: String, fileName: String) {
        guard let data = Data(base64Encoded: base64String) else {
            print("Error decoding base64 string")
            return
        }
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsPath.appendingPathComponent(fileName)
        do {
            try data.write(to: fileURL)
            // After saving, wait for user interaction to present the alert
            presentFileSavedAlert(filePath: fileURL) { action in
                // Optionally handle different actions here if needed
                print("User selected: \(action)")
            }
        } catch {
            print("Error saving file: \(error)")
        }
    }
}
