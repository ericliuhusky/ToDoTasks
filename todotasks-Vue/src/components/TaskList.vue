<template>
  <div><task-item v-for="task in tasks" v-bind:key="task.id" :task="task"></task-item></div>
</template>

<script>
import TaskItem from "./TaskItem.vue";
import Task from "../model/Task.js";
export default {
  data() {
    return {
      tasks: [
        new Task("1", false, false),
        new Task("2", true, false),
        new Task("3", false, false),
      ],
    };
  },
  components: { TaskItem },
};
</script>

<style>
</style>