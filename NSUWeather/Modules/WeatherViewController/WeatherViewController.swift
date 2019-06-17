import Cocoa
import WebKit

final class WeatherViewController: NSViewController {
    @IBOutlet private var webView: WKWebView!
    
    private lazy var pageTransformer = WeatherViewController.loadTransformationCode()
}

// MARK: - Lifecycle

extension WeatherViewController {
    override func viewWillAppear() {
        super.viewWillAppear()
        loadPage()
    }
}

// MARK: - Fabric method

extension WeatherViewController {
    class func create() -> WeatherViewController {
        let storyboard = NSStoryboard(name: "WeatherViewController", bundle: nil)
        let identifier = "WeatherViewController"
        
        guard let weatherVC = storyboard.instantiateController(withIdentifier: identifier) as? WeatherViewController else {
            fatalError()
        }
        
        NSLayoutConstraint.activate([
            weatherVC.view.heightAnchor.constraint(equalToConstant: 550),
            weatherVC.view.widthAnchor.constraint(equalToConstant: 550)
        ])
        
        return weatherVC
    }
}

// MARK: - WKNavigationDelegate implementation

extension WeatherViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        transformPage()
    }
}

// MARK: - Javascript helpers

private extension WeatherViewController {
    func loadPage() {
        let url = URL(string: "http://weather.nsu.ru")!
        webView.load(URLRequest(url: url))
    }
    
    func transformPage() {
        webView.evaluateJavaScript(pageTransformer) { (_, error) in
            error.flatMap { print($0) }
        }
    }
}

// MARK: - Load transforming code

private extension WeatherViewController {
    class func loadTransformationCode() -> String {
        guard let path = Bundle.main.url(forResource: "WeatherTransform", withExtension: "js") else {
            fatalError("Couldn't find WeatherTransform.js")
        }
        
        guard let jsCode = try? String(contentsOf: path) else {
            fatalError("Couldn't read WeatherTransform.js")
        }
        
        return jsCode
    }
}

