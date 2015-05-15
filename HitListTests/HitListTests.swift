//
//  HitListTests.swift
//  HitListTests
//
//  Created by Kevin Kane on 5/12/15.
//  Copyright (c) 2015 KevinKane. All rights reserved.
//

import UIKit
import XCTest
import KIF

class HitListTests: KIFTestCase {
    
    override func beforeEach(){
        
    }
    override func afterEach(){
        
    }
    
    override func beforeAll() {
        deleteAllNames()
    }
    
    override func afterAll() {
    }
    
    // MARK: Test Cases
    
    func testA_AddName(){
        for i in 1...5 {
            addName("Test" + String(i))
        }
    }
    
    func testB_AddNameCancel(){
        let entry1 = numberOfEntries()
        addCancel("")
        addCancel("Hello")
        if entry1 != numberOfEntries(){ tester().fail()
        }
    }
    
    func testC_DeleteTopName(){
        let t = tester()
        let tableView = t.waitForViewWithAccessibilityLabel("tableView") as! UITableView
        deleteName(NSIndexPath(forRow: 0, inSection: 0), tableView: tableView)
    }
    
    func testD_DeleteAllNames(){
        deleteAllNames()
    }
    
    func testE_SwitchToDogHouseAndBoop(){
        let t = tester()
        t.tapViewWithAccessibilityLabel("DogHouse")
        t.waitForAnimationsToFinish()
        t.tapViewWithAccessibilityLabel("PartyFacesButton")
        t.tapViewWithAccessibilityLabel("PartyFacesButton")
        t.tapViewWithAccessibilityLabel("PartyFacesButton")
        t.tapViewWithAccessibilityLabel("PartyFacesButton")
        t.tapViewWithAccessibilityLabel("PartyFacesButton")
        t.waitForAnimationsToFinish()
        t.tapViewWithAccessibilityLabel("PartyFacesButton")
        t.tapViewWithAccessibilityLabel("PartyFacesButton")
        t.tapViewWithAccessibilityLabel("PartyFacesButton")
    }
    
    func testF_SwitchToInitialBathtubAndAdd(){
        let t = tester()
        t.tapViewWithAccessibilityLabel("Bathtub")
        t.waitForAnimationsToFinish()
        addName("BathtubTesting")
    }
    
    
    
    
    
    
    // MARK: Helper Functions

    func numberOfEntries() -> Int{
        let t = tester()
        let tableView = t.waitForViewWithAccessibilityLabel("tableView") as! UITableView
       return tableView.numberOfRowsInSection(0)
    }
    
    func addName(name: String){
        let t = tester()
        t.tapViewWithAccessibilityLabel("Add")
        t.enterTextIntoCurrentFirstResponder(name)
        t.tapViewWithAccessibilityLabel("Save")
    }
    
    func addCancel(name: String){
        let t = tester()
        t.tapViewWithAccessibilityLabel("Add")
        t.enterTextIntoCurrentFirstResponder(name)
        t.tapViewWithAccessibilityLabel("Cancel")
    }
    
    func deleteName(indexPath: NSIndexPath, tableView: UITableView){
        let t = tester()
        t.swipeRowAtIndexPath(indexPath, inTableView: tableView, inDirection: KIFSwipeDirection.Left)
        t.tapViewWithAccessibilityLabel("Delete")
    }
    
    func deleteAllNames(){
        let t = tester()
        let tableView = t.waitForViewWithAccessibilityLabel("tableView") as! UITableView
        
        while tableView.numberOfRowsInSection(0) > 0 {
            deleteName(NSIndexPath(forRow: 0, inSection: 0), tableView: tableView)
        }
    }
}