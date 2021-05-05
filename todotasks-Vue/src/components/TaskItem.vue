<template>
  <swipe-delete>
    <check-box :isDone="task.isDone"></check-box>
    <task-content :text="task.content"></task-content>
    <star></star>
  </swipe-delete>
</template>

<script>
import CheckBox from "./CheckBox.vue";
import Star from "./Star.vue";
import SwipeDelete from "./SwipeDelete.vue";
import TaskContent from "./TaskContent.vue";
import Task from "../model/Task.js";
export default {
  props: {
    task: Task,
  },
  components: {
    CheckBox,
    TaskContent,
    Star,
    SwipeDelete,
  },
};
</script>

<style>
</style>