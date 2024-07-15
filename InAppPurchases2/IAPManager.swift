//
//  IAPManager.swift
//  IAPConsumable
//
//  Created by Rohit Kumar on 12/07/2024.
//

import Foundation
import StoreKit

enum Product: String, CaseIterable {
    case gem_500
    case gem_1000
    case gem_2500
    case gem_5000
    
    var count : Int {
        switch self {
        case .gem_500:
            return 500
        case .gem_1000:
            return 1000
        case .gem_2500:
            return 2500
        case .gem_5000:
            return 5000
        }
    }
}

final class IAPManager : NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    static let shared = IAPManager()
    
    var products = [SKProduct]()
    private var completion : ((Int)-> Void)?
    
    func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: Set(Product.allCases.compactMap({ $0.rawValue })))
        request.delegate = self
        request.start()
    }
    
    public func purchase(product: Product, completion: @escaping ((Int)-> Void)) {
        guard SKPaymentQueue.canMakePayments() else { return }
        guard let storeKitProduct = products.first(where: { $0.productIdentifier == product.rawValue}) else { return }
        self.completion = completion
        let paymentRequest = SKPayment(product: storeKitProduct)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(paymentRequest)
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        //Handle Transactions
        transactions.forEach {
            switch $0.transactionState {
            case .purchasing:
                print("Purchasing")
            case .purchased:
                print("Purchased")
                if let product = Product(rawValue: $0.payment.productIdentifier) {
                    completion?(product.count)
                }
                SKPaymentQueue.default().finishTransaction($0)
                SKPaymentQueue.default().remove(self)
            case .failed:
                print("Failed")
                SKPaymentQueue.default().finishTransaction($0)
            case .restored:
                print("Restored")
                SKPaymentQueue.default().finishTransaction($0)
            case .deferred:
                print("Deferred")
            @unknown default:
                break
            }
            
        }
    }
}
