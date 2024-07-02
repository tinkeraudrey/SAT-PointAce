import UIKit

class HelloViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Create a label for displaying "Hello"
        let helloLabel = UILabel()
        helloLabel.text = "Hello"
        helloLabel.textColor = .black
        helloLabel.font = UIFont.systemFont(ofSize: 50)
        helloLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(helloLabel)
        
        // Layout constraints for the label
        NSLayoutConstraint.activate([
            helloLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            helloLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
