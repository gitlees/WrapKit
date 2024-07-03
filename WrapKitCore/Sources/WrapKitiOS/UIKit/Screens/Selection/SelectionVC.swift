//
//  SelectionVC.swift
//  WrapKit
//
//  Created by Daniiar Erkinov on 3/7/24.
//

import Foundation
import UIKit
import BottomSheet

class SelectionVC: ViewController<SelectionContentView> {
    private let presenter: SelectionInput
    private lazy var datasource = TableViewDatasource<SelectionType.SelectionCellPresentableModel>(configureCell: { [weak self] tableView, indexPath, model in
        let cell: SelectionCell = tableView.dequeueReusableCell(for: indexPath)
        cell.model = model
        cell.mainContentView.trailingImageContainerView.isHidden = !(self?.presenter.isMultipleSelectionEnabled ?? false) == true
        cell.mainContentView.onPress = { [indexPath] in
            self?.presenter.onSelect(at: indexPath.row)
        }
        return cell
    })
    
    init(contentView: SelectionContentView, presenter: SelectionInput) {
        self.presenter = presenter
        super.init(contentView: contentView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTitles()
        setupUI()
        presenter.viewDidLoad()
    }
    
    private func setupTitles() {
        contentView.searchBar.textfield.placeholder = "Search"
        contentView.resetButton.setTitle("Reset", for: .normal)
        contentView.selectButton.setTitle("Select", for: .normal)
    }
    
    private func setupUI() {
        contentView.navigationBar.closeButton.onPress = presenter.onTapClose
        contentView.resetButton.onPress = presenter.onTapReset
        contentView.selectButton.onPress = presenter.onTapFinishSelection
        contentView.tableView.delegate = datasource
        contentView.tableView.dataSource = datasource
        contentView.searchBar.textfield.didChangeText.append(presenter.onSearch)
        contentView.stackView.isHidden = !presenter.isMultipleSelectionEnabled
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let calculatedHeight = contentView.tableView.contentSize.height +
        contentView.navigationBar.frame.height +
        contentView.lineView.frame.height +
        (contentView.searchBarConstraints?.height?.constant ?? 0) +
        (contentView.searchBarConstraints?.top?.constant ?? 0) +
        contentView.stackView.frame.height +
        (contentView.tableViewConstraints?.top?.constant ?? 0)
        
        let bottomViewHeight = contentView.stackView.bounds.height + 24 + 24//CGFloat.safeBottomAreaHeight
        
        if presenter.isMultipleSelectionEnabled {
            if ((window?.bounds.height ?? 0) - contentView.stackView.bounds.height) > calculatedHeight {
                preferredContentSize = CGSize(
                    width: (window?.bounds.width ?? 0),
                    height: calculatedHeight + contentView.stackView.bounds.height
                )
            } else {
                preferredContentSize = CGSize(
                    width: (window?.bounds.width ?? 0),
                    height: calculatedHeight
                )
                contentView.tableView.contentInset = .init(top: 0, left: 0, bottom: bottomViewHeight, right: 0)
            }
        } else {
            preferredContentSize = CGSize(
                width: (window?.bounds.width ?? 0),
                height: calculatedHeight
            )
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SelectionVC: SelectionOutput {
    func display(canReset: Bool) {
        if canReset {
            contentView.resetButton.setTitleColor(UIColor.black, for: .normal)
            contentView.resetButton.layer.borderColor = UIColor.gray.cgColor
        } else {
            contentView.resetButton.setTitleColor(UIColor.gray, for: .normal)
            contentView.resetButton.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    func display(shouldShowSearchBar: Bool) {
        contentView.searchBar.isHidden = !shouldShowSearchBar
        contentView.searchBarConstraints?.height?.constant = shouldShowSearchBar ? 44 : 0
        contentView.searchBarConstraints?.top?.constant = shouldShowSearchBar ? 8 : 0
        contentView.tableViewConstraints?.top?.constant = shouldShowSearchBar ? 16 : 8
    }
    
    func display(items: [SelectionType.SelectionCellPresentableModel]) {
        datasource.getItems = { items }
        let selectedItemsCount = items.filter { $0.isSelected }.count
        contentView.selectButton.setTitle("\("select")\(selectedItemsCount == 0 ? "" : " (\(selectedItemsCount))")", for: .normal)
        contentView.tableView.reloadData()
    }
    
    func display(title: String?) {
        contentView.navigationBar.titleViews.keyLabel.text = title
    }
}

extension SelectionVC: ScrollableBottomSheetPresentedController {
    var scrollView: UIScrollView? { contentView.tableView }
}
