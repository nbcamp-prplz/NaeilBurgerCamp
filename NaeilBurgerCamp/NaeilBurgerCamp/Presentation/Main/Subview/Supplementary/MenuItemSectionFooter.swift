import UIKit

protocol MenuItemFooterViewDelegate: AnyObject {
    func didTapPreviousButton()
    func didTapNextButton()
}

final class MenuItemSectionFooter: UICollectionReusableView {
    weak var delegate: MenuItemFooterViewDelegate?

    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .bcBackground2
        view.layer.cornerRadius = 2

        return view
    }()

    private let previousButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .bcPrimary

        return button
    }()

    private let nextButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .bcPrimary

        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable, message: "storyboard is not supported")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateButtonState(isPreviousEnabled: Bool, isNextEnabled: Bool) {
        previousButton.isEnabled = isPreviousEnabled
        previousButton.alpha = isPreviousEnabled ? 1.0 : 0.3

        nextButton.isEnabled = isNextEnabled
        nextButton.alpha = isNextEnabled ? 1.0 : 0.3
    }
}

private extension MenuItemSectionFooter {
    func configure() {
        setLayout()
        setHierarchy()
        setConstraints()
        setActions()
    }

    func setLayout() {
        backgroundColor = .bcBackground1
    }

    func setHierarchy() {
        addSubviews(divider, previousButton, nextButton)
    }

    func setConstraints() {
        divider.snp.makeConstraints { make in
            make.directionalHorizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(4)
        }

        previousButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }

        nextButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
    }

    func setActions() {
        previousButton.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }

    @objc func previousButtonTapped() {
        delegate?.didTapPreviousButton()
    }

    @objc func nextButtonTapped() {
        delegate?.didTapNextButton()
    }
}

extension MenuItemSectionFooter: BCReusableView {
    static var identifier: String {
        "MenuItemSectionFooter"
    }

    static var reusableViewType: ReusableViewType {
        .footer
    }
}
