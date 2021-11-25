import UIKit


class GameViewController: UIViewController {

    @IBOutlet weak var nextDigit: UILabel!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var newGameButton: UIButton!
    
    lazy var game = Game(countItems: buttons.count) { [weak self] (status, time) in
        // MARK: проверка self, чтобы не писать self?
        guard let self = self else {return}
        if Settings.shared.currentSettings.timerState{
            self.timerLabel.text = time.secondToString()
        }
        self.updateInfoGame(with: status)
    }
    
    // MARK: при уходе из формы, останавливаем игру
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        game.stopGame()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
    }
    
    // MARK: обработка нажатия на кнопку
    @IBAction func pressButton(_ sender: UIButton) {
        guard let buttonIndex = buttons.firstIndex(of: sender) else {
            return
        }
        game.check(index:buttonIndex)
        updateUI()
    }
    
    // MARK: Обработка кнопки "Новая игра"
    @IBAction func newGame(_ sender: UIButton) {
        game.newGame()
        sender.isHidden = true
        setupScreen()
    }
    
    private func setupScreen(){
        for index in game.items.indices{
            buttons[index].setTitle(game.items[index].title, for: .normal)
            buttons[index].alpha = 1
            buttons[index].isEnabled = true
        }
        
        nextDigit.text = game.nextItem?.title
    }
    
    private func updateUI(){
        for index in game.items.indices{
            buttons[index].alpha = game.items[index].isFound ? 0 : 1
            buttons[index].isEnabled = !game.items[index].isFound
            
            if game.items[index].isError {
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.buttons[index].backgroundColor = .red
                } completion: { [weak self] (_) in
                    self?.buttons[index].backgroundColor = .white
                    self?.game.items[index].isError = false
                }

            }
        }
        nextDigit.text = game.nextItem?.title
        
        updateInfoGame(with: game.status)
    }
    
    // MARK: Проверяет статус игры
    private func updateInfoGame(with status:StatusGame) {
        switch status {
        case .start:
            statusLabel.text = "Игра началась :s"
            statusLabel.textColor = .black
            newGameButton.isHidden = true
        case .win:
            statusLabel.text = "Вы выйграли! :)"
            statusLabel.textColor = .green
            newGameButton.isHidden = false
            
            if game.isNewRecord {
                showAlert()
            } else {
                showAlertActionSheet()
            }
        case .lose:
            statusLabel.text = "Вы проиграли! :("
            statusLabel.textColor = .red
            newGameButton.isHidden = false
            showAlertActionSheet()
        }
    }
    
    // MARK: выводит alert - инфа о новом рекорде если .win
    private func showAlert() {
        let alert  = UIAlertController(
            title: "Поздравляем!",
            message: "Вы установили новый рекорд",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: выводит второй вариант alert, когда пользователь проиграл
    private func showAlertActionSheet() {
        let alert = UIAlertController(
            title: "Что вы хотите сделать?",
            message: nil,
            preferredStyle: .actionSheet
        )
        let newGameAction = UIAlertAction(title: "Начать новую игру", style: .default) { [weak self] (_) in
            self?.game.newGame()
            self?.setupScreen()
        }
        
        let showRecord = UIAlertAction(title: "Посмотреть рекорд", style: .default) { [weak self] (_) in
            self?.performSegue(withIdentifier: "recordVC", sender: nil)
        }
        
        let menuAction = UIAlertAction(title: "Перейти в меню", style: .destructive) { [weak self] (_) in
            self?.navigationController?.popViewController(animated: true)
        }
        let canselAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alert.addAction(newGameAction)
        alert.addAction(showRecord)
        alert.addAction(menuAction)
        alert.addAction(canselAction)
        
        // нужен для IPad
        if let popover = alert.popoverPresentationController {
            // привязка алерта к элементу на экране
            popover.sourceView = statusLabel
            
            // если sourceView = self.view, то ...
//            popover.sourceRect = CGRect(
//                x: self.view.bounds.midX,
//                y: self.view.bounds.midY,
//                width: 0,
//                height: 0
//            )
//            // убирает стрелочку
//            popover.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
        }
        
        present(alert, animated: true, completion: nil)
    }
    
}
