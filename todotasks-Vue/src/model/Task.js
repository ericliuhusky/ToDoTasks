class Task {
    constructor(content, isDone, isStarred) {
        this.content = content
        this.isDone = isDone
        this.isStarred = isStarred
        this.creationTime = Date()
    }
}

export default Task