
import Foundation
extension String{
    func matches(for regex: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
//            return results.map {
//                String(self[Range($0.range, in: self)!])
//            }
            return true
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return false
        }
    }
}
