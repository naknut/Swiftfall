import Foundation

class Swiftfall {
    
    static let scryfall = "https://api.scryfall.com/"
    
    struct Error: Codable{
        var code: String
        var type: String
        var status: Int
        var details: String
        
        init(code:String,type: String,status:Int,details:String) {
            self.code = code
            self.type = type
            self.status = status
            self.details = details
        }
        
        func simplePrint(){
            print("Details:\(details)\n")
        }
    }
    
    public struct SetList: Codable {
        var data: [Set?]
        
        func simplePrint(){
            var i = 0
            for set in data {
                if let t_set = set{
                    print("Set Number: \(i)")
                    t_set.simplePrint()
                    i = i + 1
                }
            }
        }
    }
    
    public struct Set: Codable {
        var code: String?
        var mtgo: String?
        var name: String
        var uri: String
        var scryfall_uri: String
        var search_uri: String
        var released_at: String?
        var set_type: String
        var card_count: Int
        var digital: Bool
        var foil: Bool
        var block_code: String?
        var block: String?
        var icon_svg_uri: String
        
        func simplePrint(){
            if let block = self.block , let code = self.code, let release_at = self.released_at {
                print("Name: \(name) (\(code))\nBlock: \(block)\nNumber of Cards: \(card_count)\nRelease Date: \(release_at)\nSet Type: \(set_type)\n")
            }
            else {
                print("Name: \(name)\nNumber of Cards: \(card_count)\nSet Type:\(set_type)\n")
            }
        }
    }

    public struct Card:Codable {
        // Core Card Fields
        var id:String
        var oracle_id:String
        var multiverse_ids:[Int]
        var mtgo_id:Int?
        var mtgo_foil_id:Int?
        var name:String
        
        var uri:String
        var scryfall_uri:String
        var prints_search_uri:String
        var rulings_uri:String
        
        var layout:String
        var cmc:Int
        var type_line:String
        var oracle_text:String
        var mana_cost:String
        var power: String?
        var toughness: String?
        var colors:[String]
        
        var purchase_uris: [String:String]
        
        public func simplePrint(){
            let simple = "Name: \(name)\nCost: \(mana_cost)\nType Line: \(type_line)\nOracle Text:\n\(oracle_text)\n"
            if self.power != nil && self.toughness != nil {
                print("\(simple)Power: \(power!)\nToughness: \(toughness!)\n")
            } else {print(simple)}
        }
    }
    
    // fuzzy
    public static func getCard(fuzzy: String) -> Card?
    {
        let encodeFuzz = fuzzy.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let call = "cards/named?fuzzy=\(encodeFuzz)"

        var card: Card?
        var stop = false
        parseCard(call: call){
            (newcard:Card?) in
            card = newcard
            stop = true
        }
        
        while(!stop){
            // Do this until parseCard is done
        }
        
        return card
    }
    
    // exact
    public static func getCard(exact: String) -> Card?
    {
        let encodeExactly = exact.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let call = "cards/named?exact=\(encodeExactly)"
        
        var card: Card?
        var stop = false
        parseCard(call: call){
            (newcard:Card?) in
            card = newcard
            stop = true
        }
        
        while(!stop){
            //Do this until parseCard is done
        }
        
        return card
    }
    
    /// Retreives JSON data from URL and parses it with JSON decoder. Thanks Mitchell
    static func parseCard(call:String, completion: @escaping (Card?) -> ()) {
        
        let url = URL(string: "\(scryfall)\(call)")
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            
            guard let content = data else {
                print("Error: There was no data returned from JSON file.")
                return
            }
    
            //print("\(String(data: content,encoding: .utf8))")
            
            let decoder = JSONDecoder()
            do {
                // Decode JSON file starting from Response struct.
                let decoded:Card = try decoder.decode(Card.self, from: content)
                completion(decoded)
            }
            catch {
                // Known Issues:
                //  * Too broad of a request (needs handler) 
                //
                // Present an alert if the JSON data cannot be decoded.
                do {
                    let decoded:Error = try decoder.decode(Error.self, from: content)
                    decoded.simplePrint()
                }
                catch {
                    print("Error: \(error)")
                    completion(nil)
                }
                completion(nil)
            }
        }
        task.resume()
    }
    
    // set
    public static func getSet(code: String) -> Set?
    {
        let encodeExactly = code.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let call = "sets/\(encodeExactly)"
        
        var set: Set?
        var stop = false
        parseCard(call: call){
            (newset:Set?) in
            set = newset
            stop = true
        }
        
        while(!stop){
            //Do this until parseCard is done
        }
        
        return set
    }
    
    /// Retreives JSON data from URL and parses it with JSON decoder. Thanks Mitchell
    static func parseCard(call:String, completion: @escaping (Set?) -> ()) {
        
        let url = URL(string: "\(scryfall)\(call)")
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            
            guard let content = data else {
                print("Error: There was no data returned from JSON file.")
                return
            }
            
            //print("\(String(data: content,encoding: .utf8))")
            
            let decoder = JSONDecoder()
            do {
                // Decode JSON file starting from Response struct.
                let decoded:Set = try decoder.decode(Set.self, from: content)
                completion(decoded)
            }
            catch {
                // Known Issues:
                //  * Too broad of a request (needs handler)
                //
                // Present an alert if the JSON data cannot be decoded.
                do {
                    let decoded:Error = try decoder.decode(Error.self, from: content)
                    decoded.simplePrint()
                }
                catch {
                    print("Error: \(error)")
                    completion(nil)
                }
                completion(nil)
            }
        }
        task.resume()
    }
    
    public static func getSetList() -> SetList?
    {
        let call = "sets/"
        
        var setlist: SetList?
        var stop = false
        parseSetList(call: call){
            (newset:SetList?) in
            setlist = newset
            stop = true
        }
        
        while(!stop){
            //Do this until parseCard is done
        }
        
        return setlist
    }
    
    /// Retreives JSON data from URL and parses it with JSON decoder. Thanks Mitchell
    static func parseSetList(call:String, completion: @escaping (SetList?) -> ()) {
        
        let url = URL(string: "\(scryfall)\(call)")
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            
            guard let content = data else {
                print("Error: There was no data returned from JSON file.")
                return
            }
            
            //print("\(String(data: content,encoding: .utf8))")
            
            let decoder = JSONDecoder()
            do {
                // Decode JSON file starting from Response struct.
                let decoded:SetList = try decoder.decode(SetList.self, from: content)
                completion(decoded)
            }
            catch {
                do {
                    let decoded:Error = try decoder.decode(Error.self, from: content)
                    decoded.simplePrint()
                }
                catch {
                    print("Error: \(error)")
                    
                    completion(nil)
                }
                completion(nil)
            }
        }
        task.resume()
    }
    
}

