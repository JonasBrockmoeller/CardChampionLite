//
//  ShopView.swift
//  Placeholder
//
//  Created by Jonas Brockmöller on 11.05.22.
//
/*
 Tutorial used: https://www.youtube.com/watch?v=JJG3xI5FmFY&t=1243s
 https://iosexample.com/implementing-and-testing-in-app-purchases-with-storekit2-in-xcode-13-swift-5-5-and-ios-15/
 */

import StoreKit
import SwiftUI
public typealias ProductId = String
typealias CompletionHandler = (_ success:Bool) -> Void

@available(iOS 15.0, macOS 12.0, *)
class InAppPurchaseModel: ObservableObject{
    var products: [Product] = []
    
    init(){
        let productIds = ["com.cardChampion.commonPack", "com.cardChampion.rarePack", "com.cardChampion.epicPack", "com.cardChampion.legendaryPack"]
        // Get localized product info from the App Store
        Task.init {
            if let products = await requestProductsFromAppStore(productIds: productIds){
                self.products = products
                //print(products)
            }
        }
    }
    
    @MainActor public func requestProductsFromAppStore(productIds: [ProductId]) async -> [Product]? {
        try? await Product.products(for: productIds)
    }
    
    func purchase(product: Product, completionHandler: @escaping CompletionHandler){
        Task.init
        {
            do{
                let result = try await product.purchase(options: [.appAccountToken(UUID())])
                //print(result)
                switch result{
                    case .success(let verification):
                        switch verification{
                            case .unverified(let transaction, _):
                                await transaction.finish()
                                completionHandler(false)
                                break
                            case .verified(let transaction):
                                await transaction.finish()
                                completionHandler(true)
                        }
                    case .userCancelled, .pending:
                        completionHandler(false)
                    @unknown default:
                        completionHandler(false)
                }
            } catch{
                print(error)
            }
        }
    }
}

struct ShopView: View {
    @EnvironmentObject var purchaseModel: InAppPurchaseModel
    @State var showAlert = false
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack{
            Capsule()
                .fill(.gray)
                .frame(width: 40, height: 7)
                .padding(.top)
            
            HStack{
                getPack(productIndex: 0)
                getPack(productIndex: 1)
            }
            
            HStack{
                getPack(productIndex: 2)
                getPack(productIndex: 3)
            }
        }
    }
    
    func getPack(productIndex: Int) -> some View{
        guard purchaseModel.products.indices.contains(productIndex) else {
            return AnyView(VStack{
                Image("LoadingIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Text("Error loading Product")
            })
        }
        
        let product = purchaseModel.products[productIndex]
        
        return AnyView(VStack{
            Image("\(product.displayName)-pack")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Button(action:{
                purchaseModel.purchase(product: product, completionHandler: { (success) -> Void in
                    // When purchase request completes,control flow goes here.
                    if success {
                        self.isPresented.toggle()
                    } else {
                        self.showAlert = true
                    }
                })
            }){
                Text(product.displayPrice)
                    .frame(width: 100, height: 50)
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(10)
            }
            .alert("An error occured. Please try again",
                   isPresented: $showAlert) {
                Button(action:{
                }){
                    Text("OK")
                        .bold()
                }
            }
        }
        )
    }
}

/*
struct ShopView_Previews: PreviewProvider {
    static var previews: some View {
        ShopView()
            .environmentObject(InAppPurchaseModel())
    }
}
*/
