import UIKit

final actor OngoingTaskStore<T: Sendable> {
    private var tasks: [String: Task<T?, Never>] = [:]

    func task(for key: String) -> Task<T?, Never>? {
        return tasks[key]
    }

    func setTask(_ task: Task<T?, Never>, for key: String) {
        tasks[key] = task
    }

    func removeTask(for key: String) {
        tasks[key] = nil
    }

    func clear() {
        tasks.removeAll()
    }
}
