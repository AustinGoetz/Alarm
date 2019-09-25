//
//  AlarmDetailTableViewController.swift
//  myAlarm
//
//  Created by Austin Goetz on 9/24/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {
    
    var alarm: Alarm?{
        didSet{
            loadViewIfNeeded()
            self.updateViews()
        }
    }
    
    var alarmIsOn: Bool = true
    
    // MARK: - Outlets
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var alarmNameTextField: UITextField!
    @IBOutlet weak var alarmEnabledButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func updateViews() {
        guard let alarm = alarm else { return }
        alarmIsOn = alarm.enabled
        datePicker.date = alarm.fireDate
        alarmNameTextField.text = alarm.name
        setUpAlarmButton()
    }
    
    func setUpAlarmButton(){

        switch alarmIsOn {
        case true:
            alarmEnabledButton.backgroundColor = UIColor.green
            alarmEnabledButton.setTitle("ON", for: .normal)
        case false:
            alarmEnabledButton.backgroundColor = UIColor.gray
            alarmEnabledButton.setTitle("Off", for: .normal)
        }
    }


    // MARK: - Actions
    @IBAction func enableButtonTapped(_ sender: UIButton) {
        if let alarm = alarm {
            AlarmController.sharedInstance.toggleEnabled(alarm: alarm)
            alarmIsOn = alarm.enabled
        } else {
            alarmIsOn = !alarmIsOn
        }
        setUpAlarmButton()
        
        
    }
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = alarmNameTextField.text else { return }
        guard title != "" else { return }
        if let alarm = alarm {
            AlarmController.sharedInstance.updateAlarm(alarm: alarm, fireDate: datePicker.date, name: title, enabled: alarmIsOn)
        } else { return }
        AlarmController.sharedInstance.addAlarm(fireDate: datePicker.date, name: title, enabled: alarmIsOn, uuid: "\(UUID())")
        // SO CLOSE. I can't figure this part out. Specifically the uuid portion. But I messed up the name: too
        self.navigationController?.popViewController(animated: true)
    }
}
