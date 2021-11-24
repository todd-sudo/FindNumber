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
    
    var currentSettings: SettingsGame {
        
        get {
            
        }
        
        set {
//            do{
//                let data = try PropertyListEncoder().encode(newValue)
//            }catch{
//                print()
//            }
            if let data = try? PropertyListEncoder().encode(newValue){
                UserDefaults.standard.setValue(data, forKey: KeysUserDefaults.settingsGame)
            }
        }
    }
}
