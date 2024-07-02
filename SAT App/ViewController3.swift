import UIKit

class ViewController3: UIViewController {
    
    // Properties to store reward information
    var rewards: [Reward] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Create "Add Reward" button
        let addButton = UIButton(type: .system)
        addButton.setTitle("Add Reward", for: .normal)
        addButton.setTitleColor(.black, for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(addRewardButtonTapped), for: .touchUpInside)
        
        view.addSubview(addButton)
        
        // Layout constraints for the button
        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -720)
        ])
    }
    
    @objc func addRewardButtonTapped() {
        // Create an alert controller with text fields
        let alertController = UIAlertController(title: "Add Reward",
                                                message: nil,
                                                preferredStyle: .alert)
        
        alertController.addTextField { (nameTextField) in
            nameTextField.placeholder = "Reward Name"
        }
        
        alertController.addTextField { (descriptionTextField) in
            descriptionTextField.placeholder = "Description (optional)"
        }
        
        alertController.addTextField { (numberTextField) in
            numberTextField.placeholder = "Assign a Number"
            numberTextField.keyboardType = .numberPad
        }
        
        // Add action for "Add" button
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] (_) in
            guard let nameTextField = alertController.textFields?[0],
                  let descriptionTextField = alertController.textFields?[1],
                  let numberTextField = alertController.textFields?[2],
                  let rewardName = nameTextField.text, !rewardName.isEmpty else {
                return
            }
            
            let rewardDescription = descriptionTextField.text ?? ""
            let assignedNumberText = numberTextField.text ?? ""
            if let assignedNumber = Int(assignedNumberText) {
                // Create a reward object and store it
                let reward = Reward(name: rewardName, description: rewardDescription, number: assignedNumber)
                self?.rewards.append(reward)
                
                // Update UI to display the rewards
                self?.updateUI()
            }
        }
        alertController.addAction(addAction)
        
        // Add cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
    
    // Function to update UI with rewards
    func updateUI() {
        // Remove previous reward labels
        view.subviews.forEach { subview in
            if subview.tag == 100 {
                subview.removeFromSuperview()
            }
        }
        
        // Display rewards
        var yOffset: CGFloat = 150.0
        for (index, reward) in rewards.enumerated() {
            let titleLabel = UILabel(frame: CGRect(x: 20, y: yOffset, width: view.frame.width - 40, height: 30))
            titleLabel.text = "\(reward.name)"
            titleLabel.textColor = .black
            titleLabel.font = UIFont.systemFont(ofSize: 25)
            titleLabel.tag = 100 // Set tag for later removal
            view.addSubview(titleLabel)
            
            let descriptionLabel = UILabel(frame: CGRect(x: 20, y: yOffset + 30, width: view.frame.width - 40, height: 50))
            descriptionLabel.text = "\(reward.description)"
            descriptionLabel.textColor = .darkGray
            descriptionLabel.font = UIFont.systemFont(ofSize: 18)
            descriptionLabel.numberOfLines = 0
            descriptionLabel.tag = 100 // Set tag for later removal
            view.addSubview(descriptionLabel)
            
            let numberLabel = UILabel(frame: CGRect(x: 20, y: yOffset + 80, width: view.frame.width - 40, height: 30))
            numberLabel.text = "Points: \(reward.number)"
            numberLabel.textColor = .blue
            numberLabel.font = UIFont.boldSystemFont(ofSize: 18)
            numberLabel.tag = 100 // Set tag for later removal
            view.addSubview(numberLabel)
            
            yOffset += 130 // Increase yOffset for next reward
        }
    }
}

// Reward struct to hold reward information
struct Reward {
    let name: String
    let description: String
    let number: Int
}
