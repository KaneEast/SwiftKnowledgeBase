import Foundation

// MARK: - Protocols
protocol FileDownloadDelegate: AnyObject {
    func downloadDidStart(fileName: String)
    func downloadDidProgress(fileName: String, progress: Double)
    func downloadDidComplete(fileName: String, success: Bool)
    func downloadDidFail(fileName: String, error: String)
}

protocol UserValidationDelegate: AnyObject {
    func validationDidStart(for field: String)
    func validationDidSucceed(for field: String)
    func validationDidFail(for field: String, error: String)
}

// MARK: - Delegating Objects
class FileDownloader {
    weak var delegate: FileDownloadDelegate?
    private var isDownloading = false
    
    func downloadFile(named fileName: String) {
        guard !isDownloading else {
            delegate?.downloadDidFail(fileName: fileName, error: "Another download in progress")
            return
        }
        
        isDownloading = true
        delegate?.downloadDidStart(fileName: fileName)
        
        // Simulate download progress
        simulateDownload(fileName: fileName)
    }
    
    private func simulateDownload(fileName: String) {
        var progress: Double = 0.0
        
        // Simulate progress updates
        for i in 1...5 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.5) {
                progress = Double(i) * 0.2
                self.delegate?.downloadDidProgress(fileName: fileName, progress: progress)
                
                if i == 5 {
                    self.isDownloading = false
                    let success = Bool.random() // Random success/failure
                    if success {
                        self.delegate?.downloadDidComplete(fileName: fileName, success: true)
                    } else {
                        self.delegate?.downloadDidFail(fileName: fileName, error: "Network timeout")
                    }
                }
            }
        }
    }
}

class UserValidator {
    weak var delegate: UserValidationDelegate?
    
    func validateEmail(_ email: String) {
        delegate?.validationDidStart(for: "email")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if email.contains("@") && email.contains(".") {
                self.delegate?.validationDidSucceed(for: "email")
            } else {
                self.delegate?.validationDidFail(for: "email", error: "Invalid email format")
            }
        }
    }
    
    func validatePassword(_ password: String) {
        delegate?.validationDidStart(for: "password")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if password.count >= 8 {
                self.delegate?.validationDidSucceed(for: "password")
            } else {
                self.delegate?.validationDidFail(for: "password", error: "Password must be at least 8 characters")
            }
        }
    }
}

// MARK: - Mock View Classes
class MockDownloadView: FileDownloadDelegate {
    private let viewName: String
    
    init(viewName: String) {
        self.viewName = viewName
    }
    
    func downloadDidStart(fileName: String) {
        print("[\(viewName)] Download started: \(fileName)")
        print("[\(viewName)] Showing loading spinner...")
    }
    
    func downloadDidProgress(fileName: String, progress: Double) {
        let percentage = Int(progress * 100)
        print("[\(viewName)] Download progress: \(fileName) - \(percentage)%")
        print("[\(viewName)] Updating progress bar to \(percentage)%")
    }
    
    func downloadDidComplete(fileName: String, success: Bool) {
        if success {
            print("[\(viewName)] ✅ Download completed: \(fileName)")
            print("[\(viewName)] Hiding loading spinner")
            print("[\(viewName)] Showing success message")
        } else {
            print("[\(viewName)] ❌ Download failed: \(fileName)")
            print("[\(viewName)] Hiding loading spinner")
        }
    }
    
    func downloadDidFail(fileName: String, error: String) {
        print("[\(viewName)] ❌ Download failed: \(fileName)")
        print("[\(viewName)] Error: \(error)")
        print("[\(viewName)] Hiding loading spinner")
        print("[\(viewName)] Showing error alert")
    }
}

class MockValidationView: UserValidationDelegate {
    private let viewName: String
    
    init(viewName: String) {
        self.viewName = viewName
    }
    
    func validationDidStart(for field: String) {
        print("[\(viewName)] Validating \(field)...")
        print("[\(viewName)] Showing validation spinner for \(field)")
    }
    
    func validationDidSucceed(for field: String) {
        print("[\(viewName)] ✅ \(field) validation passed")
        print("[\(viewName)] Showing green checkmark for \(field)")
    }
    
    func validationDidFail(for field: String, error: String) {
        print("[\(viewName)] ❌ \(field) validation failed")
        print("[\(viewName)] Error: \(error)")
        print("[\(viewName)] Showing red error icon for \(field)")
    }
}

// MARK: - Usage Example
class DelegationPatternExample {
    static func run() {
        print("🤝 Delegation Pattern Example")
        print("=============================")
        
        // Example 1: File Download with Delegation
        print("\n--- File Download Example ---")
        let downloadView1 = MockDownloadView(viewName: "MainView")
        let downloadView2 = MockDownloadView(viewName: "DetailView")
        
        let downloader1 = FileDownloader()
        let downloader2 = FileDownloader()
        
        // Set delegates
        downloader1.delegate = downloadView1
        downloader2.delegate = downloadView2
        
        // Start downloads
        downloader1.downloadFile(named: "document.pdf")
        downloader2.downloadFile(named: "image.jpg")
        
        // Example 2: User Validation with Delegation
        print("\n--- User Validation Example ---")
        let loginView = MockValidationView(viewName: "LoginView")
        let signupView = MockValidationView(viewName: "SignupView")
        
        let validator1 = UserValidator()
        let validator2 = UserValidator()
        
        // Set delegates
        validator1.delegate = loginView
        validator2.delegate = signupView
        
        // Validate different inputs
        validator1.validateEmail("user@example.com")
        validator1.validatePassword("securepass123")
        
        validator2.validateEmail("invalid-email")
        validator2.validatePassword("weak")
        
        // Example 3: Multiple delegates for same downloader
        print("\n--- Multiple Views Example ---")
        let notificationView = MockDownloadView(viewName: "NotificationView")
        let progressView = MockDownloadView(viewName: "ProgressView")
        
        let sharedDownloader = FileDownloader()
        
        // First view handles the download
        sharedDownloader.delegate = notificationView
        sharedDownloader.downloadFile(named: "update.zip")
        
        // Later, switch delegate to different view
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            print("\n--- Switching delegate ---")
            sharedDownloader.delegate = progressView
            sharedDownloader.downloadFile(named: "data.json")
        }
    }
}

// Uncomment to run the example
// DelegationPatternExample.run()