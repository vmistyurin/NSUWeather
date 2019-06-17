import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

    private var context: Context!
    private var statusBarHandler: StatusBarHandler!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.context = Context()
        self.statusBarHandler = StatusBarHandler(context: context)
    }
}
