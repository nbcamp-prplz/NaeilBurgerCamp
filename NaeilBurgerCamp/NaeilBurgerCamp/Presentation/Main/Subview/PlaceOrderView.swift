import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PlaceOrderView: UIView {
    let cancelButtonTapped = PublishRelay<Void>()
    let orderButtonTapped = PublishRelay<Void>()
    private let disposeBag = DisposeBag()

    private lazy var franchiseLabel: UILabel = {
        let label = UILabel()
        label.text = "내버캠 iOS 마스터 3호점"
        label.textColor = .bcMocha
        label.font = .nanumSquareRound(ofSize: 13, weight: .heavy)

        return label
    }()

    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        return stackView
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .bcBackground4
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.bcBlack, for: .normal)
        button.titleLabel?.font = .nanumSquareRound(ofSize: 15, weight: .heavy)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true

        return button
    }()

    private lazy var orderButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .bcPrimary
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .nanumSquareRound(ofSize: 15, weight: .heavy)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true

        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable, message: "storyboard is not supported")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    func updateCancelButtonIsEnabled(_ isEnabled: Bool) {
        UIView.transition(with: cancelButton, duration: 0.2, options: .transitionCrossDissolve) {
            self.cancelButton.isHidden = !isEnabled
        }
    }

    func updateOrderButtonIsEnabled(_ isEnabled: Bool) {
        orderButton.isEnabled = isEnabled
        orderButton.layer.opacity = isEnabled ? 1.0 : 0.5
    }

    func updateOrderButtonTitle(with cart: Cart) {
        let title = cart.totalQuantity == 0
            ? "항목을 추가해주세요!"
            : "(\(cart.totalQuantity)) \(cart.totalPrice)원 결제하기"
        orderButton.setTitle(title, for: .normal)
    }
}

private extension PlaceOrderView {
    func configure() {
        setLayout()
        setHierarchy()
        setConstraints()
        setBinding()
    }

    func setLayout() {
        backgroundColor = .bcBackground3

        layer.shadowColor = UIColor(named: "BCBlack")?.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: -2)
    }

    func setHierarchy() {
        buttonsStackView.addArrangedSubviews(cancelButton, orderButton)
        addSubviews(franchiseLabel, buttonsStackView)
    }

    func setConstraints() {
        franchiseLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.leading.equalToSuperview().inset(24)
        }

        buttonsStackView.snp.makeConstraints { make in
            make.top.equalTo(franchiseLabel.snp.bottom).offset(14)
            make.directionalHorizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }

        cancelButton.snp.makeConstraints { make in
            make.width.equalTo(90)
            make.height.equalTo(42)
        }

        orderButton.snp.makeConstraints { make in
            make.height.equalTo(42)
        }
    }

    func setBinding() {
        cancelButton.rx.tap
            .bind(to: cancelButtonTapped)
            .disposed(by: disposeBag)

        orderButton.rx.tap
            .bind(to: orderButtonTapped)
            .disposed(by: disposeBag)
    }
}
