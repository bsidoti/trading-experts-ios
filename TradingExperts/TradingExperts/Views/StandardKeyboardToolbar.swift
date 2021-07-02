//
//  StandardKeyboardToolbar
//  TradingExperts
//
//  Created by Braden Sidoti on 12/1/18.
//  Copyright © 2018 Braden Sidoti. All rights reserved.
//

import UIKit

protocol KeyboardAvoidingProtocol: class {
    var lastScrollViewOffset: CGPoint { get set }
    var scrollViewBottomConstraint: NSLayoutConstraint! { get }
    var scrollView: UIScrollView! { get }
    
    func setupKeyboardAvoidance()
}

extension KeyboardAvoidingProtocol {
    func setupKeyboardAvoidance() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main) { (notification) in
            self.lastScrollViewOffset = self.scrollView.contentOffset
            
            guard let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else {
                return
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                var bottomSafeArea: CGFloat = 0
                
                if let bottom = UIApplication.shared.windows.first?.safeAreaInsets.bottom {
                    bottomSafeArea += bottom
                }
                
                self.scrollViewBottomConstraint.constant = keyboardHeight - bottomSafeArea
            })
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main) { (notification) in
            UIView.animate(withDuration: 0.3, animations: {
                self.scrollViewBottomConstraint.constant = 0
                self.scrollView.contentOffset = self.lastScrollViewOffset
            })
        }

    }
}

protocol StandardKeyboardToolbarDelegate: class {
    func donePressed()
}

class StandardKeyboardToolbar: UIToolbar {
    var doneButton: UIBarButtonItem!
    
    weak var standardKeyboardToolbarDelegate: StandardKeyboardToolbarDelegate?
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
        
        let attrs = [NSAttributedString.Key.font: TEFont.barlow(weight: .semiBold, size: 16),
                     NSAttributedString.Key.foregroundColor: UIColor.te_green]
        
        doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(StandardKeyboardToolbar.doDone))
        doneButton.setTitleTextAttributes(attrs, for: .normal)
        
        let rightSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        items = [rightSpace, doneButton]
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func doDone() {
        standardKeyboardToolbarDelegate?.donePressed()
    }
}
