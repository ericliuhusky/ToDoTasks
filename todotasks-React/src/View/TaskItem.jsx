import React from 'react'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faCircle, faCheck } from '@fortawesome/free-solid-svg-icons'
import { Row, Col, Input } from 'antd'

class TaskItem extends React.Component {
    render() {
        return (
            <SwipeDelete>
                <Row>
                    <Col span={3}>
                        <CheckBox isDone={this.props.task.isDone}></CheckBox>
                    </Col>
                    <Col span={18}>
                        <TaskContent text={this.props.task.content}></TaskContent>
                    </Col>
                </Row>
            </SwipeDelete>
        )
    }
}

class CheckBox extends React.Component {
    constructor(props) {
        super(props)
        this.state = { isDone: this.props.isDone }
        this.toggle = this.toggle.bind(this)
    }
    toggle(e) {
        //  阻止冒泡事件
        e.stopPropagation()
        this.setState({ isDone: !this.state.isDone })
    }
    render() {
        return <FontAwesomeIcon icon={this.state.isDone ? faCheck : faCircle} onClick={this.toggle}></FontAwesomeIcon>
    }
}

class TaskContent extends React.Component {
    render() {
        return <Input value={this.props.text}></Input>
    }
}

class Star extends React.Component {
    render() {
        return <></>
    }
}

class SwipeDelete extends React.Component {
    constructor(props) {
        super(props)
        this.state = {
            left: 24,
            right: 0
        }
        this.translate = this.translate.bind(this)
    }
    translate() {
        this.setState({
            left: 16,
            right: 8
        })
    }
    render() {
        return (
            <Row onClick={this.translate}>
                <Col span={this.state.left}>{this.props.children}</Col>
                <Col span={this.state.right}>
                </Col>
            </Row>
        )
    }
}

export default TaskItem