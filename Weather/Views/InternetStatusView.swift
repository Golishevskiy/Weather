//
//  InternetStatusView.swift
//  Weather
//
//  Created by Petro Golishevskiy on 16.06.2023.
//

import UIKit

class InternetStatusView: UIView {
    private var internetStatusLabel: UILabel!
    private var isConnected: String!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        
        // Додавання в'ю зі статусом підключення до Інтернету
        let viewHeight: CGFloat = 50
        let viewWidth = bounds.width - 40 // Відступи зліва та справа по 20 пікселів
        let startY = -viewHeight // Початкова позиція поза екраном
        let internetStatusView = UIView(frame: CGRect(x: 20, y: startY, width: viewWidth, height: viewHeight))
        internetStatusView.backgroundColor = .green // Зелений колір для підключення до Інтернету
        internetStatusView.clipsToBounds = true
        addSubview(internetStatusView)
        
        // Додавання мітки зі статусом підключення
        internetStatusLabel = UILabel(frame: CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight))
        internetStatusLabel.textAlignment = .center
        internetStatusLabel.textColor = .white
        internetStatusLabel.font = UIFont.boldSystemFont(ofSize: 18)
        internetStatusView.addSubview(internetStatusLabel)
        
        // Оновлення статусу підключення
//        updateInternetStatus()
    }
    
    private func updateInternetStatus() {
        let isConnected = checkInternetConnection() // Функція для перевірки підключення до Інтернету
        
        if isConnected {
            internetStatusLabel.text = "Connected"
        } else {
            internetStatusLabel.text = "Disconnected"
        }
    }
    
    private func checkInternetConnection() -> Bool {
        // Метод для перевірки підключення до Інтернету (реалізуйте його залежно від ваших потреб)
        return true // Повертаємо true, якщо підключення активне, або false, якщо відсутнє
    }
    
    func show(label: String) {
        isConnected = label
        // Додавати InternetStatusView до основної в'ю з анімацією
        frame.origin.y = -frame.height

        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.frame.origin.y = 80 // Позиція зверху екрану з відступом 20 пікселів
        }, completion: nil)

        superview?.addSubview(self)
        
        // Ховати в'ю після 3 секунд
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.frame.origin.y = -self.frame.height
            }, completion: { _ in
                self.removeFromSuperview()
            })
        }
    }
}
