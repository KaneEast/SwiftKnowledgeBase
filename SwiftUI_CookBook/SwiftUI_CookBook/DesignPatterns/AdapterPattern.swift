import Foundation

// MARK: - Media Player Adapter Example

// Target interface - what the client expects
fileprivate protocol MediaPlayer {
    func play(audioType: String, fileName: String)
}

// Adaptee 1 - Advanced audio player with different interface
fileprivate final class AdvancedAudioPlayer {
    func playMP3(fileName: String) {
        print("🎵 Playing MP3 file: \(fileName)")
    }
    
    func playAAC(fileName: String) {
        print("🎵 Playing AAC file: \(fileName)")
    }
}

// Adaptee 2 - Video player with different interface
fileprivate final class VideoPlayer {
    func playMP4(fileName: String) {
        print("🎬 Playing MP4 video: \(fileName)")
    }
    
    func playAVI(fileName: String) {
        print("🎬 Playing AVI video: \(fileName)")
    }
}

// Adapter - converts incompatible interfaces
fileprivate final class MediaAdapter: MediaPlayer {
    private let audioPlayer: AdvancedAudioPlayer
    private let videoPlayer: VideoPlayer
    
    init() {
        self.audioPlayer = AdvancedAudioPlayer()
        self.videoPlayer = VideoPlayer()
    }
    
    func play(audioType: String, fileName: String) {
        switch audioType.lowercased() {
        case "mp3":
            audioPlayer.playMP3(fileName: fileName)
        case "aac":
            audioPlayer.playAAC(fileName: fileName)
        case "mp4":
            videoPlayer.playMP4(fileName: fileName)
        case "avi":
            videoPlayer.playAVI(fileName: fileName)
        default:
            print("❌ \(audioType) format not supported")
        }
    }
}

// Client - uses the Target interface
fileprivate final class AudioPlayer: MediaPlayer {
    private let adapter: MediaAdapter
    
    init() {
        self.adapter = MediaAdapter()
    }
    
    func play(audioType: String, fileName: String) {
        if audioType.lowercased() == "mp3" {
            print("🎵 Playing built-in MP3: \(fileName)")
        } else {
            // Use adapter for other formats
            adapter.play(audioType: audioType, fileName: fileName)
        }
    }
}

// MARK: - Payment Gateway Adapter Example

// Target interface - what our application expects
fileprivate protocol PaymentProcessor {
    func processPayment(amount: Double, currency: String) -> PaymentResult
    func refundPayment(transactionId: String, amount: Double) -> PaymentResult
}

fileprivate struct PaymentResult {
    let success: Bool
    let transactionId: String?
    let errorMessage: String?
    
    static func success(transactionId: String) -> PaymentResult {
        return PaymentResult(success: true, transactionId: transactionId, errorMessage: nil)
    }
    
    static func failure(error: String) -> PaymentResult {
        return PaymentResult(success: false, transactionId: nil, errorMessage: error)
    }
}

// Adaptee 1 - Legacy PayPal API
fileprivate final class LegacyPayPalAPI {
    func makePayment(amountInCents: Int, currencyCode: String) -> (Bool, String?) {
        let transactionId = "PP_\(UUID().uuidString.prefix(8))"
        print("💳 PayPal: Processing \(amountInCents) cents in \(currencyCode)")
        
        let success = amountInCents > 0
        return (success, success ? transactionId : nil)
    }
    
    func processRefund(transactionRef: String, refundAmountCents: Int) -> Bool {
        print("💳 PayPal: Refunding \(refundAmountCents) cents for transaction \(transactionRef)")
        return true
    }
}

// Adaptee 2 - Third-party Stripe API
fileprivate final class StripeAPIClient {
    func charge(dollars: Double, currency: String) -> [String: Any] {
        let transactionId = "stripe_\(UUID().uuidString.prefix(8))"
        print("💳 Stripe: Charging $\(dollars) \(currency)")
        
        return [
            "id": transactionId,
            "status": dollars > 0 ? "succeeded" : "failed",
            "amount": dollars
        ]
    }
    
    func createRefund(chargeId: String, amount: Double) -> [String: Any] {
        print("💳 Stripe: Creating refund of $\(amount) for charge \(chargeId)")
        return [
            "id": "refund_\(UUID().uuidString.prefix(8))",
            "status": "succeeded"
        ]
    }
}

// Adapter 1 - PayPal Adapter
fileprivate final class PayPalAdapter: PaymentProcessor {
    private let paypalAPI: LegacyPayPalAPI
    
    init() {
        self.paypalAPI = LegacyPayPalAPI()
    }
    
    func processPayment(amount: Double, currency: String) -> PaymentResult {
        let amountInCents = Int(amount * 100)
        let (success, transactionId) = paypalAPI.makePayment(amountInCents: amountInCents, currencyCode: currency)
        
        if success, let id = transactionId {
            return PaymentResult.success(transactionId: id)
        } else {
            return PaymentResult.failure(error: "PayPal payment failed")
        }
    }
    
    func refundPayment(transactionId: String, amount: Double) -> PaymentResult {
        let amountInCents = Int(amount * 100)
        let success = paypalAPI.processRefund(transactionRef: transactionId, refundAmountCents: amountInCents)
        
        if success {
            return PaymentResult.success(transactionId: "refund_\(transactionId)")
        } else {
            return PaymentResult.failure(error: "PayPal refund failed")
        }
    }
}

// Adapter 2 - Stripe Adapter
fileprivate final class StripeAdapter: PaymentProcessor {
    private let stripeAPI: StripeAPIClient
    
    init() {
        self.stripeAPI = StripeAPIClient()
    }
    
    func processPayment(amount: Double, currency: String) -> PaymentResult {
        let result = stripeAPI.charge(dollars: amount, currency: currency)
        
        if let status = result["status"] as? String, status == "succeeded",
           let transactionId = result["id"] as? String {
            return PaymentResult.success(transactionId: transactionId)
        } else {
            return PaymentResult.failure(error: "Stripe payment failed")
        }
    }
    
    func refundPayment(transactionId: String, amount: Double) -> PaymentResult {
        let result = stripeAPI.createRefund(chargeId: transactionId, amount: amount)
        
        if let status = result["status"] as? String, status == "succeeded",
           let refundId = result["id"] as? String {
            return PaymentResult.success(transactionId: refundId)
        } else {
            return PaymentResult.failure(error: "Stripe refund failed")
        }
    }
}

// MARK: - Data Format Adapter Example

// Target interface - what our app expects
fileprivate protocol DataParser {
    func parse(_ data: String) -> [String: Any]
    func serialize(_ data: [String: Any]) -> String
}

// Adaptee 1 - XML Parser with different interface
fileprivate final class XMLParser {
    func parseXMLString(_ xml: String) -> XMLNode? {
        print("🔍 Parsing XML: \(xml.prefix(50))...")
        return XMLNode(tag: "root", attributes: ["type": "data"], content: "parsed content")
    }
    
    func xmlNodeToString(_ node: XMLNode) -> String {
        return "<\(node.tag) \(node.attributes.map { "\($0.key)=\"\($0.value)\"" }.joined(separator: " "))>\(node.content)</\(node.tag)>"
    }
}

fileprivate struct XMLNode {
    let tag: String
    let attributes: [String: String]
    let content: String
}

// Adaptee 2 - CSV Parser with different interface
fileprivate final class CSVParser {
    func parseCSVData(_ csv: String) -> [[String]] {
        print("🔍 Parsing CSV: \(csv.prefix(50))...")
        let rows = csv.components(separatedBy: "\n")
        return rows.map { $0.components(separatedBy: ",") }
    }
    
    func arrayToCSV(_ data: [[String]]) -> String {
        return data.map { $0.joined(separator: ",") }.joined(separator: "\n")
    }
}

// Adapter 1 - XML Adapter
fileprivate final class XMLAdapter: DataParser {
    private let xmlParser: XMLParser
    
    init() {
        self.xmlParser = XMLParser()
    }
    
    func parse(_ data: String) -> [String: Any] {
        guard let xmlNode = xmlParser.parseXMLString(data) else {
            return [:]
        }
        
        return [
            "tag": xmlNode.tag,
            "attributes": xmlNode.attributes,
            "content": xmlNode.content,
            "format": "XML"
        ]
    }
    
    func serialize(_ data: [String: Any]) -> String {
        let tag = data["tag"] as? String ?? "data"
        let attributes = data["attributes"] as? [String: String] ?? [:]
        let content = data["content"] as? String ?? ""
        
        let xmlNode = XMLNode(tag: tag, attributes: attributes, content: content)
        return xmlParser.xmlNodeToString(xmlNode)
    }
}

// Adapter 2 - CSV Adapter
fileprivate final class CSVAdapter: DataParser {
    private let csvParser: CSVParser
    
    init() {
        self.csvParser = CSVParser()
    }
    
    func parse(_ data: String) -> [String: Any] {
        let rows = csvParser.parseCSVData(data)
        
        return [
            "rows": rows,
            "rowCount": rows.count,
            "columnCount": rows.first?.count ?? 0,
            "format": "CSV"
        ]
    }
    
    func serialize(_ data: [String: Any]) -> String {
        if let rows = data["rows"] as? [[String]] {
            return csvParser.arrayToCSV(rows)
        }
        return ""
    }
}

// MARK: - Universal Data Processor using Adapters
fileprivate final class DataProcessor {
    private let xmlAdapter: XMLAdapter
    private let csvAdapter: CSVAdapter
    
    init() {
        self.xmlAdapter = XMLAdapter()
        self.csvAdapter = CSVAdapter()
    }
    
    func processData(_ data: String, format: String) -> [String: Any] {
        let parser: DataParser
        
        switch format.lowercased() {
        case "xml":
            parser = xmlAdapter
        case "csv":
            parser = csvAdapter
        default:
            print("❌ Unsupported format: \(format)")
            return [:]
        }
        
        return parser.parse(data)
    }
    
    func exportData(_ data: [String: Any], format: String) -> String {
        let parser: DataParser
        
        switch format.lowercased() {
        case "xml":
            parser = xmlAdapter
        case "csv":
            parser = csvAdapter
        default:
            return ""
        }
        
        return parser.serialize(data)
    }
}

// MARK: - Usage Example
fileprivate final class AdapterPatternExample {
    static func run() {
        print("🔌 Adapter Pattern Example")
        print("==========================")
        
        print("\n--- Media Player Adapter ---")
        let audioPlayer = AudioPlayer()
        
        audioPlayer.play(audioType: "mp3", fileName: "song.mp3")
        audioPlayer.play(audioType: "aac", fileName: "song.aac")
        audioPlayer.play(audioType: "mp4", fileName: "video.mp4")
        audioPlayer.play(audioType: "avi", fileName: "movie.avi")
        audioPlayer.play(audioType: "flac", fileName: "music.flac")
        
        print("\n--- Payment Gateway Adapters ---")
        let paymentProcessors: [String: PaymentProcessor] = [
            "PayPal": PayPalAdapter(),
            "Stripe": StripeAdapter()
        ]
        
        for (gatewayName, processor) in paymentProcessors {
            print("\n--- Testing \(gatewayName) ---")
            
            let paymentResult = processor.processPayment(amount: 99.99, currency: "USD")
            if paymentResult.success {
                print("✅ Payment successful: \(paymentResult.transactionId ?? "N/A")")
                
                if let transactionId = paymentResult.transactionId {
                    let refundResult = processor.refundPayment(transactionId: transactionId, amount: 50.0)
                    if refundResult.success {
                        print("✅ Refund successful: \(refundResult.transactionId ?? "N/A")")
                    } else {
                        print("❌ Refund failed: \(refundResult.errorMessage ?? "Unknown error")")
                    }
                }
            } else {
                print("❌ Payment failed: \(paymentResult.errorMessage ?? "Unknown error")")
            }
        }
        
        print("\n--- Data Format Adapters ---")
        let dataProcessor = DataProcessor()
        
        let xmlData = "<user id=\"123\"><name>John Doe</name><email>john@example.com</email></user>"
        let csvData = "Name,Email,Age\nJohn Doe,john@example.com,30\nJane Smith,jane@example.com,25"
        
        print("--- Processing XML ---")
        let xmlResult = dataProcessor.processData(xmlData, format: "XML")
        print("Parsed XML: \(xmlResult)")
        
        print("\n--- Processing CSV ---")
        let csvResult = dataProcessor.processData(csvData, format: "CSV")
        print("Parsed CSV: \(csvResult)")
        
        print("\n--- Exporting Data ---")
        let dataToExport: [String: Any] = [
            "tag": "export",
            "attributes": ["version": "1.0"],
            "content": "Exported data"
        ]
        
        let exportedXML = dataProcessor.exportData(dataToExport, format: "XML")
        print("Exported XML: \(exportedXML)")
        
        let csvDataToExport: [String: Any] = [
            "rows": [["Name", "Age"], ["Alice", "28"], ["Bob", "32"]]
        ]
        let exportedCSV = dataProcessor.exportData(csvDataToExport, format: "CSV")
        print("Exported CSV: \(exportedCSV)")
        
        print("\n--- Adapter Pattern Benefits ---")
        print("✅ Enables integration with incompatible interfaces")
        print("✅ Promotes code reuse without modification")
        print("✅ Separates interface conversion from business logic")
        print("✅ Allows legacy systems to work with new code")
        print("✅ Supports multiple third-party integrations")
    }
}

// Uncomment to run the example
// AdapterPatternExample.run()