import UIKit

protocol HeaderViewDelegate: AnyObject {
  @MainActor
  func headerView(_ headerView: HeaderView, didPressDeleteButton deleteButton: UIButton)
  @MainActor
  func headerView(_ headerView: HeaderView, didPressCloseButton closeButton: UIButton)
  @MainActor
  func headerView(_ headerView: HeaderView, didPressShareButton shareButton: UIButton)
}

open class HeaderView: UIView {
  open fileprivate(set) lazy var closeButton: UIButton = { [unowned self] in
    let title = NSAttributedString(
      string: LightboxConfig.CloseButton.text,
      attributes: LightboxConfig.CloseButton.textAttributes)

    let button = UIButton(type: .system)
    button.setAttributedTitle(title, for: .normal)

    if let size = LightboxConfig.CloseButton.size {
      button.frame.size = size
    } else {
      button.sizeToFit()
    }

    button.addTarget(self, action: #selector(closeButtonDidPress(_:)), for: .touchUpInside)

    if let image = LightboxConfig.CloseButton.image {
      button.setBackgroundImage(image, for: .normal)
    }

    button.isHidden = !LightboxConfig.CloseButton.enabled

    return button
  }()

  open fileprivate(set) lazy var shareButton: UIButton = { [unowned self] in
    let title = NSAttributedString(
      string: LightboxConfig.ShareButton.text,
      attributes: LightboxConfig.ShareButton.textAttributes)

    let button = UIButton(type: .system)
    button.setAttributedTitle(title, for: .normal)

    if let size = LightboxConfig.ShareButton.size {
      button.frame.size = size
    } else {
      button.sizeToFit()
    }

    button.addTarget(self, action: #selector(shareButtonDidPress(_:)), for: .touchUpInside)

    if let image = LightboxConfig.ShareButton.image {
      button.setBackgroundImage(image, for: .normal)
    }

    button.isHidden = !LightboxConfig.ShareButton.enabled

    return button
  }()

  open fileprivate(set) lazy var deleteButton: UIButton = { [unowned self] in
    let title = NSAttributedString(
      string: LightboxConfig.DeleteButton.text,
      attributes: LightboxConfig.DeleteButton.textAttributes)

    let button = UIButton(type: .system)
    button.setAttributedTitle(title, for: .normal)

    if let size = LightboxConfig.DeleteButton.size {
      button.frame.size = size
    } else {
      button.sizeToFit()
    }

    button.addTarget(self, action: #selector(deleteButtonDidPress(_:)), for: .touchUpInside)

    if let image = LightboxConfig.DeleteButton.image {
      button.setBackgroundImage(image, for: .normal)
    }

    button.isHidden = !LightboxConfig.DeleteButton.enabled

    return button
  }()

  weak var delegate: (any HeaderViewDelegate)?

  // MARK: - Initializers

  public init() {
    super.init(frame: .zero)
    backgroundColor = .clear
    [closeButton, shareButton, deleteButton].forEach { addSubview($0) }
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Actions

  @objc func deleteButtonDidPress(_ button: UIButton) {
    delegate?.headerView(self, didPressDeleteButton: button)
  }

  @objc func closeButtonDidPress(_ button: UIButton) {
    delegate?.headerView(self, didPressCloseButton: button)
  }

  @objc func shareButtonDidPress(_ button: UIButton) {
    delegate?.headerView(self, didPressShareButton: button)
  }
}

// MARK: - LayoutConfigurable

extension HeaderView: LayoutConfigurable {
  @objc public func configureLayout() {
    let topPadding: CGFloat = {
      if #available(iOS 11, *) {
        return safeAreaInsets.top
      } else {
        return 0
      }
    }()
      let leftPadding: CGFloat = {
        if #available(iOS 11, *) {
          return safeAreaInsets.left
        } else {
          return 0
        }
      }()
      let rightPadding: CGFloat = {
        if #available(iOS 11, *) {
          return safeAreaInsets.right
        } else {
          return 0
        }
      }()

    closeButton.frame.origin = CGPoint(
      x: bounds.width - closeButton.frame.width - 17 - rightPadding,
      y: topPadding
    )

    shareButton.frame.origin = CGPoint(
      x: closeButton.frame.minX - shareButton.frame.width - 18,
      y: topPadding
    )

    deleteButton.frame.origin = CGPoint(
      x: 17 + leftPadding,
      y: topPadding
    )
  }
}
