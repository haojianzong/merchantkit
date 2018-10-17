import UIKit
import MerchantKit

@UIApplicationMain
public class AppDelegate: UIResponder, UIApplicationDelegate {
    public var window: UIWindow?

    private var merchant: Merchant!
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.merchant = Merchant(storage: EphemeralPurchaseStorage(), delegate: self)
        
        let displayingProducts = [ProductDatabase.one, ProductDatabase.another]
        
        let upgradeViewController = PurchaseProductsViewController(merchant: self.merchant, displayingProducts: displayingProducts)
        let navigationController = UINavigationController(rootViewController: upgradeViewController)
        
        self.window = {
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
            
            return window
        }()
        
        return true
    }
}

extension AppDelegate : MerchantDelegate {
    public func merchant(_ merchant: Merchant, didChangeStatesFor products: Set<Product>) {
        
    }
    
    public func merchant(_ merchant: Merchant, validate request: ReceiptValidationRequest, completion: @escaping (Result<Receipt>) -> Void) {
        let validator = LocalReceiptValidator(request: request)
        validator.onCompletion = { result in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                completion(result)
            })
        }
        
        validator.start()
    }
}
