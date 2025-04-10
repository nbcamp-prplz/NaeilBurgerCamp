import UIKit

final actor OngoingTaskStore {
    private var tasks: [String: Task<Data?, Never>] = [:]

    func getTask(for key: String) -> Task<Data?, Never>? {
        return tasks[key]
    }

    func setTask(_ task: Task<Data?, Never>, for key: String) {
        tasks[key] = task
    }

    func removeTask(for key: String) {
        tasks[key] = nil
    }

    func clear() {
        tasks.removeAll()
    }
}
