//
//  NetworkManager.swift
//  Weather
//
//  Created by Petro Golishevskiy on 15.06.2023.
//

import Foundation
import Network

class NetworkManager {
    static let shared = NetworkManager()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    private var isConnected = true {
        didSet {
            notifyObservers()
        }
    }
    
    private var observers = [NetworkStatusObserver]()
    
    private init() {
        startMonitoring()
    }
    
    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            if (path.status == .satisfied) != self?.isConnected {
                self?.isConnected = (path.status == .satisfied)
                print("isConnected = \(self?.isConnected)")
            }
        }
        monitor.start(queue: queue)
    }
    
    func isInternetAvailable(completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            completion(self.isConnected)
        }
    }
    
    func addObserver(_ observer: NetworkStatusObserver) {
        observers.append(observer)
    }
    
    func removeObserver(_ observer: NetworkStatusObserver) {
        observers.removeAll(where: { $0 === observer })
    }
    
    private func notifyObservers() {
        for observer in observers {
            observer.networkStatusDidChange(isConnected)
        }
    }
}


protocol NetworkStatusObserver: AnyObject {
    func networkStatusDidChange(_ isConnected: Bool)
}



