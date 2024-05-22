import UIKit

extension URL {
    var queryDictionary: [String: String]? {
        guard let query = self.query else { return nil }
        
        var queryStrings = [String: String]()
        for pair in query.components(separatedBy: "&") {
            let key = pair.components(separatedBy: "=")[0]
            
            let value = pair
                .components(separatedBy: "=")[1]
                .replacingOccurrences(of: "+", with: " ")
                .removingPercentEncoding ?? ""
            
            queryStrings[key] = value
        }
        return queryStrings
    }
}

func test(url: String) {
    let url = URL(string: url)!
    print(url.absoluteString)
    
    var nativeUrl = url.absoluteString
    // Find the range of the first "&" symbol
    if !nativeUrl.contains("?"),
       let range = nativeUrl.range(of: "&") {
        // Replace the first "&" with "?"
        nativeUrl.replaceSubrange(range, with: "?")
    }
    let params = URL(string: nativeUrl)!.queryDictionary
    print(params)
}

test(url: "http://isbtestintegration.abb-bank.az/api/v1/abb-insurance-ms/isb-client/successcallback-property&policyNumber=RAT2400001538&token=sadas")


