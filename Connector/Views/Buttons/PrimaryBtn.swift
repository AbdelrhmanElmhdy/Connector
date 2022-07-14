import UIKit

class PrimaryBtn: UIButton {
    enum BtnTheme {
        case accent, white
    }
	    
    var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        indicator.isHidden = true
        
        return indicator
    }()
    
    var title = ""
    var theme: BtnTheme = .accent
        
    var isLoading = false {
        didSet {
            isEnabled = !isLoading
            activityIndicator.isHidden = !isLoading
            isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        }
    }
    
	init(title: String = "", theme: BtnTheme) {
        super.init(frame: .zero)
        
        self.title = title
        self.theme = theme
        
        setup()
        setupActivityIndicator()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	    
    func setup() {
        if !title.isEmpty {
            setTitle(title, for: .normal)
        }
        
        layer.cornerRadius = 8
        
        if theme == .accent {
            backgroundColor = .accent
            activityIndicator.color = .white
            setTitleColor(.white, for: .normal)
        } else {
            backgroundColor = .white
            activityIndicator.color = .accent
            setTitleColor( .accent, for: .normal)
        }
        
        let highlightedTitleColor = titleColor(for: .normal)?.withAlphaComponent(0.3)
        setTitleColor(highlightedTitleColor, for: .highlighted)
    }
    
    func setupActivityIndicator() {
        addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.topAnchor.constraint(equalTo: topAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: bottomAnchor),
            activityIndicator.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
        ])
    }
	
}
