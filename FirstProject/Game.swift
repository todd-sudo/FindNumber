import Foundation


// MARK: Статусы игры
enum StatusGame {
    case start
    case win
    case lose
}

// MARK: Модель Игры
class Game {
    
    struct Item {
        var title: String
        var isFound: Bool = false
        var isError: Bool = false
    }
    
    private let data = Array(1...99)
    private var countItems: Int
    private var timeForGame: Int
    private var secondsGame: Int {
        didSet{
            if secondsGame == 0 {
                status = .lose
            }
            // MARK: обновляем таймер
            updateTimer(status, secondsGame)
        }
    }
    private var timer: Timer?
    private var updateTimer: ((StatusGame, Int) -> Void)
    
    var items: [Item] = []
    var nextItem: Item?
    var status: StatusGame = .start {
        didSet{
            if status != .start {
                stopGame()
            }
        }
    }
    
    // MARK: Инициализация.
    // MARK: @escaping - нужен для того чтобы вызывать ее после init, в  didSet`е timeForGame
    init(countItems: Int, updateTimer:@escaping (_ status: StatusGame, _ second: Int) -> Void) {
        self.countItems = countItems
        self.timeForGame = Settings.shared.currentSettings.timeForGame
        self.secondsGame = self.timeForGame
        self.updateTimer = updateTimer
        setupGame()
    }
    
    // MARK: Проверяет нажатие на число, если верно, то список перемешивается и запрашивается новое число
    func check(index: Int) {
        guard status == .start else {return}
        
        if items[index].title == nextItem?.title{
            items[index].isFound = true
            nextItem = items.shuffled().first(where: { (item) -> Bool in
                item.isFound == false
            })
            
        } else {
            items[index].isError = true
        }
        
        if nextItem == nil{
            status = .win
        }
    }
    
    // MARK: Перезапускает игру
    func newGame() {
        status = .start
        self.secondsGame = self.timeForGame
        setupGame()
    }
    
    // MARK: Загружает игру.
    private func setupGame() {
        var digits = data.shuffled()
        
        items.removeAll()
        
        while items.count < countItems {
            let item = Item(title: String(digits.removeFirst()))
            items.append(item)
        }
        
        nextItem = items.shuffled().first
        
        // MARK: обновляем таймер
        updateTimer(status, secondsGame)
        
        if Settings.shared.currentSettings.timerState {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (_) in
                self?.secondsGame -= 1
            })
        }
    }
    
    // MARK: Останаваливает игру
    func stopGame() {
        timer?.invalidate()
    }
}

// MARK: Расширение для типа Int
extension Int {
    // MARK: Возвращает форматируемую строку, типа 1:02
    func secondToString() -> String {
        let minutes = self / 60
        let seconds = self % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
