import React from 'react'
import TaskItem from './TaskItem'
import Task from '../Model/Task'

class TaskList extends React.Component {
    constructor(props) {
        super(props)
        this.tasks = [
            new Task("1", false, false),
            new Task("2", false, false),
            new Task("3", false, false),
            new Task("4", false, false),
            new Task("5", false, false),
            new Task("6", false, false)
        ]
    }
    render() {
        return (
            <div>
                {
                    this.tasks.map(task => {
                        return <TaskItem task={task} key={task.id}></TaskItem>
                    })
                }
            </div>
        )
    }
}

export default TaskList