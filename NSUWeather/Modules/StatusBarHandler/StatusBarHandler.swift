import Cocoa

final class StatusBarHandler {
    private static let updateInterval: TimeInterval = 60
    
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private let popover = NSPopover()
    
    private let context: Context
    private var temperatureTimer: Timer!
    
    init(context: Context) {
        self.context = context
        
        setupStatusBarButton()
        setupPopover()
        scheduleUpdate()
    }
}

// MARK: - Setup

private extension StatusBarHandler {
    func setupStatusBarButton() {
        if let button = statusItem.button {
            button.target = self
            button.action = #selector(togglePopover(sender:))
        }
    }
    
    func setupPopover() {
        popover.contentViewController = WeatherViewController.create()
        popover.behavior = .transient
    }
    
    func scheduleUpdate() {
        temperatureTimer = Timer.scheduledTimer(
            withTimeInterval: StatusBarHandler.updateInterval, repeats: true
        ) { [weak self] _ in
            self?.context.weatherService.getTemperature { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let temperature):
                        self?.statusItem.button?.title = temperature
                    case .failure(let error):
                        self?.statusItem.button?.title = "-"
                        print(error.localizedDescription)
                    }
                }
            }
        }
        
        temperatureTimer.fire()
    }
}

// MARK: - Popover actions

private extension StatusBarHandler {
    @objc func togglePopover(sender: Any?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover()
        }
    }
    
    func showPopover() {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
    }
    
    func closePopover(sender: Any?) {
        popover.performClose(sender)
    }
}
