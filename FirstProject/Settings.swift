import Foundation

enum KeysUserDefaults {
    static let settingsGame = "settingsGame"
}

// MARK: Структура для настройки игры
struct SettingsGame: Codable{
    var timerState: Bool
    var timeForGame: Int
}

// MARK: Класс настроек игры
class Settings{
    static var shared = Settings()
    private let defaultSettings = SettingsGame(timerState: true, timeForGame: 30)
    
    // MARK: текущие настройки
    var currentSettings: SettingsGame {
        // MARK: get settings
        get {
            if let data = UserDefaults.standard.object(
                forKey: KeysUserDefaults.settingsGame
            ) as? Data{
                return try! PropertyListDecoder().decode(SettingsGame.self, from: data)
            } else {
                if let data = try? PropertyListEncoder().encode(defaultSettings){
                    UserDefaults.standard.setValue(data, forKey: KeysUserDefaults.settingsGame)
                }
                return defaultSettings
            }
        }
        
        // MARK: save settings
        set {
            if let data = try? PropertyListEncoder().encode(newValue){
                UserDefaults.standard.setValue(data, forKey: KeysUserDefaults.settingsGame)
            }
        }
    }
    
    // MARK: сброс настроек
    func resetSettings() {
        currentSettings = defaultSettings
    }
}
