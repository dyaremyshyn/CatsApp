//
//  CatsViewController.swift
//  CatsApp
//
//  Created by Dmytro Yaremyshyn on 01/09/2024.
//

import UIKit
import Combine

public class CatsViewController: UIViewController {

    private var cancellables = Set<AnyCancellable>()
    var viewModel: CatsViewModel? {
        didSet { bind() }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewModel?.loadData()
    }

    private func bind() {
        viewModel?.$fetchedBreeds
            .receive(on: DispatchQueue.main)
            .sink { [weak self] breeds in
                guard let self else { return }
                print(breeds?.count ?? "")
            }
            .store(in: &cancellables)
        
        viewModel?.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                guard let self, let message = errorMessage else { return }
                print(message)
            }
            .store(in: &cancellables)
    }

    private func setupView() {
        title = viewModel?.title
        view.backgroundColor = .systemBackground
    }
}

