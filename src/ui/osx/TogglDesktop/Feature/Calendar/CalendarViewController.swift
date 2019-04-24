//
//  CalendarViewController.swift
//  TogglDesktop
//
//  Created by Nghia Tran on 4/19/19.
//  Copyright © 2019 Alari. All rights reserved.
//

import Cocoa

protocol CalendarViewControllerDelegate: class {

    func calendarViewControllerDidSelect(date: Date)
}

final class CalendarViewController: NSViewController {

    // MARK: OUTLET

    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var popverWidth: NSLayoutConstraint!
    @IBOutlet weak var clipView: NSClipView!
    @IBOutlet weak var stackViewTrailing: NSLayoutConstraint!

    // MARK: Variables

    weak var delegate: CalendarViewControllerDelegate?
    fileprivate lazy var dataSource: CalendarDataSource = CalendarDataSource(selectedDate: selectedDate)
    private var isViewAppearing = false
    private var selectedDate = Date() {
        didSet {
            dataSource.selectedDate = selectedDate
        }
    }

    // MARK: View Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initCommon()
        initCollectionView()
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        isViewAppearing = true
        reloadCalendarView()
    }

    override func viewWillDisappear() {
        super.viewWillDisappear()
        isViewAppearing = false
    }

    // MARK: Public

    func prepareLayout(with date: Date) {
        selectedDate = date
        reloadCalendarView()
    }

    private func reloadCalendarView() {
        if isViewAppearing {
            collectionView.reloadData()
            collectionView.scrollToItems(at: Set<IndexPath>.init(arrayLiteral: IndexPath(item: dataSource.indexForCurrentDate, section: 0)),
                                         scrollPosition: [.centeredVertically])
            if let flow = collectionView.collectionViewLayout as? CalendarFlowLayout {

                // If the scroller bar is showing
                // Increase the padding
                if clipView.frame.width < 240 {
                    let width = flow.collectionViewContentSize.width
                    popverWidth.constant = width + 15
                    stackViewTrailing.constant = 20
                }
            }
        }
    }
}

// MARK: Private

extension CalendarViewController {

    fileprivate func initCommon() {
        dataSource.delegate = self
    }

    fileprivate func initCollectionView() {
        collectionView.register(NSNib(nibNamed: CalendarDataSource.Constants.cellNibName, bundle: nil),
                                forItemWithIdentifier: CalendarDataSource.Constants.cellID)
        collectionView.dataSource = dataSource
        collectionView.delegate = dataSource
        collectionView.collectionViewLayout = CalendarFlowLayout()
    }
}

extension CalendarViewController: CalendarDataSourceDelegate {

    func calendarDidSelect(_ date: Date) {
        delegate?.calendarViewControllerDidSelect(date: date)
    }
}
