import UIKit
import RxSwift
import ObjectiveC

public extension UITableViewCell {

  private struct AssociatedKeys {
    static var ReusableDisposeBag = "rx_reusableDisposeBag"
  }

  private func doLocked(closure: () -> Void) {
    objc_sync_enter(self); defer { objc_sync_exit(self) }
    closure()
  }

  var rx_reusableDisposeBag: DisposeBag {
    get {
      var reusableDisposeBag: DisposeBag!
      doLocked {
        let lookup = objc_getAssociatedObject(self, &AssociatedKeys.ReusableDisposeBag) as? DisposeBag
        if let lookup = lookup {
          reusableDisposeBag = lookup
        } else {
          let newDisposeBag = DisposeBag()
          self.rx_reusableDisposeBag = newDisposeBag
          reusableDisposeBag = newDisposeBag
        }
      }
      return reusableDisposeBag
    }

    set {
      doLocked {
        objc_setAssociatedObject(self, &AssociatedKeys.ReusableDisposeBag, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      }
    }
  }

  func rx_prepareForReuse() {
    self.rx_prepareForReuse()
    rx_reusableDisposeBag = DisposeBag()
  }

  public override class func initialize() {
    struct Static {
      static var token: dispatch_once_t = 0
    }

    // make sure this isn't a subclass
    if self !== UITableViewCell.self {
      return
    }

    dispatch_once(&Static.token) {
      let originalSelector = Selector("prepareForReuse")
      let swizzledSelector = Selector("rx_prepareForReuse")

      let originalMethod = class_getInstanceMethod(self, originalSelector)
      let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)

      let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))

      if didAddMethod {
        class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
      } else {
        method_exchangeImplementations(originalMethod, swizzledMethod)
      }
    }
  }
}
