import Foundation

class JSONDataDecoderProvider {
    func decode<T: Codable>(data: Data, by type: T) -> (APIShell<T>)? {
        let decoder = JSONDecoder()
        
        do {
            let decodedJson = try decoder.decode(APIShell<T>.self, from: data)
            return decodedJson
        } catch {
            print("Decoding error")
        }
        
        return nil
    }
}
