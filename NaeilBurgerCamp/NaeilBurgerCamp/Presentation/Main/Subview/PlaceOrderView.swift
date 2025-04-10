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
        label.text = String(.franchiseInfo)
        label.textColor = .bcText3
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
        button.setTitle(String(.cancel), for: .normal)
        button.setTitleColor(.bcText1, for: .normal)
        button.titleLabel?.font = .nanumSquareRound(ofSize: 15, weight: .heavy)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true

        return button
    }()

    private lazy var orderButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .bcPrimary
        button.setTitleColor(.bcText4, for: .normal)
        button.titleLabel?.font = .nanumSquareRound(ofSize: 15, weight: .heavy)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true

        return button
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = .bcIndicator
        indicator.hidesWhenStopped = true

        return indicator
    }()

    private lazy var orderSuccessMessageLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .bcPrimary
        label.text = String(.orderSuccess)
        label.textColor = .bcText4
        label.font = .nanumSquareRound(ofSize: 15, weight: .heavy)
        label.textAlignment = .center
        label.isHidden = true

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable, message: "storyboard is not supported")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    func updateCancelButtonIsHidden(_ isHidden: Bool) {
        UIView.transition(with: cancelButton, duration: 0.2, options: .transitionCrossDissolve) {
            self.cancelButton.isHidden = isHidden
        }
    }

    func updateOrderButtonIsEnabled(_ isEnabled: Bool) {
        orderButton.isEnabled = isEnabled
        orderButton.layer.opacity = isEnabled ? 1.0 : 0.5
    }
    
    func updateOrderButtonTitle(with cart: Cart) {
        let title = cart.totalQuantity == 0
            ? String(.pleaseAddItem)
            : String(
                .ordering,
                with: cart.totalQuantity, cart.totalPrice.numberFormatted
            )
        orderButton.setTitle(title, for: .normal)
        activityIndicator.stopAnimating()
    }

    func showOrderSuccessMessage() {
        Task {
            await MainActor.run {
                orderSuccessMessageLabel.isHidden = false
            }
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            await MainActor.run {
                UIView.animate(withDuration: 0.3, animations: {
                    self.orderSuccessMessageLabel.alpha = 0
                }, completion: { _ in
                    self.orderSuccessMessageLabel.isHidden = true
                    self.orderSuccessMessageLabel.alpha = 1
                })
            }
        }
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
        backgroundColor = .bcBackground6

        layer.shadowColor = UIColor(named: "BCBlack")?.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: -2)
    }

    func setHierarchy() {
        orderButton.addSubviews(activityIndicator, orderSuccessMessageLabel)
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
            make.bottom.equalTo(safeAreaLayoutGuide).inset(14)
        }

        cancelButton.snp.makeConstraints { make in
            make.width.equalTo(90)
            make.height.equalTo(42)
        }

        orderButton.snp.makeConstraints { make in
            make.height.equalTo(42)
        }

        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        orderSuccessMessageLabel.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
        }
    }

    func setBinding() {
        cancelButton.rx.tap
            .bind(to: cancelButtonTapped)
            .disposed(by: disposeBag)

        orderButton.rx.tap
            .bind { [weak self] in
                guard let self else { return }
                self.orderButton.setTitle("", for: .normal)
                self.activityIndicator.startAnimating()
                self.updateOrderButtonIsEnabled(false)
                self.orderButtonTapped.accept(())
            }
            .disposed(by: disposeBag)
    }
}
