import UIKit

class ViewController2: UIViewController, TimerDelegate {
    
    var totalElapsed: TimeInterval = 0
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 50)
        label.textAlignment = .center
        label.text = "00:00:00"
        return label
    }()
    
    let pointsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30)
        label.textAlignment = .center
        label.text = "Points: 0"
        return label
    }()
    
    lazy var refreshButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Refresh", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(refreshTime), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(timeLabel)
        view.addSubview(pointsLabel)
        view.addSubview(refreshButton)
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        pointsLabel.translatesAutoresizingMaskIntoConstraints = false
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            
            pointsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pointsLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 20),
            
            refreshButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            refreshButton.topAnchor.constraint(equalTo: pointsLabel.bottomAnchor, constant: 20),
        ])
        
        // Load totalElapsed from UserDefaults initially
        totalElapsed = UserDefaults.standard.double(forKey: "totalElapsed")
        
        updateTimeLabel() // Ensure time label is updated with stored value
        updatePointsLabel() // Ensure points label is updated with stored value
    }
    
    func updateTimeLabel() {
        timeLabel.text = formattedString(for: totalElapsed)
    }
    
    func updatePointsLabel() {
        pointsLabel.text = "Points: \(Int(totalElapsed))"
    }
    
    func formattedString(for timeInterval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: timeInterval) ?? "00:00:00"
    }
    
    @objc func refreshTime() {
        // Reload totalElapsed from UserDefaults
        totalElapsed = UserDefaults.standard.double(forKey: "totalElapsed")
        updateTimeLabel()
        updatePointsLabel()
    }
    
    // Implement TimerDelegate method to update totalElapsed
    func timerDidFinish(totalElapsed: TimeInterval) {
        self.totalElapsed = totalElapsed
        updateTimeLabel()
        updatePointsLabel()
    }
}

