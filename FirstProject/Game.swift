import Foundation


class Game {
    
    
    struct Item {
        var title: String
        var isFound: Bool = false
    }
    
    private let data = Array(1...99)
    
    var items: [Item] = []
    
    private var countItems: Int
    
    init(countItems: Int) {
        self.countItems = countItems
        
        setupGame()
    }
    
    private func setupGame(){
        var digits = data.shuffled()
        
        while items.count < countItems {
            let item = Item(title: String(digits.removeFirst()))
            items.append(item)
        }
    }
}
