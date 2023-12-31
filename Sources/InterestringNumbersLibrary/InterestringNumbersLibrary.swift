
#if canImport(UIKit)
import UIKit
#endif
import Foundation

public protocol NumbersManagerDelegate {
    func didUpdateNumberFacts(_ manager: NumbersManager, facts: [String: String])
    func didFailWithError(error: Error)
}

public class NumbersManager {
    let factsURL = "http://numbersapi.com/"
    public var delegate: NumbersManagerDelegate?
    public var isParseOneFact = true
    public var userInputNumber = ""
    // URL session injection for testing
    let session: URLSession
    public init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    public func fetchFacts(numbers: String){
        let urlString = "\(factsURL)\(numbers)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let task = session.dataTask(with: url) { [weak self] data, response, error in
                if error != nil {
                    self?.delegate?.didFailWithError(error: error!)
                    return
                }
                if let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode != 200  {
                        let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: nil)
                        self?.delegate?.didFailWithError(error: error)
                        return
                    }
                
                if let safeData = data {
                    // if the user chose to see one fact
                    if self?.isParseOneFact == true {
                        if let factsString = String(data: safeData, encoding: .utf8),
                           let facts = self?.parseFactsString(factsString),
                           let manager = self {
                            self?.delegate?.didUpdateNumberFacts(manager, facts: facts)
                        }
                    } else {
                        // the user decided to see two facts
                        if let facts = self?.parseJSONToFacts(safeData),
                           let manager = self {
                            self?.delegate?.didUpdateNumberFacts(manager, facts: facts)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSONToFacts(_ data: Data) -> [String: String]? {
        let decoder = JSONDecoder()
        do {
            let facts = try decoder.decode([String: String].self, from: data)
            return facts
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    func parseFactsString(_ string: String) -> [String: String] {
        // Assuming that the string is a single fact about a number
        return [userInputNumber: string]
    }

}

