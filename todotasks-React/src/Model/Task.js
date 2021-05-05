import { v4 as uuidv4 } from 'uuid'

class Task {
    constructor(content, isDone, isStarred) {
        this.id = uuidv4()
        this.content = content
        this.isDone = isDone
        this.isStarred = isStarred
        this.creationTime = Date()
    }
}

export default Task