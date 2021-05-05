<template>
  <font-awesome-icon
    v-bind:icon="isDoneState ? 'check' : 'circle'"
    v-on:click="toggle"
  />
</template>

<script>
export default {
  props: {
    isDone: Boolean,
  },
  data() {
    return {
      isDoneState: false,
    };
  },
  created() {
    this.isDoneState = this.isDone;
  },
  methods: {
    toggle() {
      if (this.isDoneState) {
        this.isDoneState = false;
      } else {
        this.isDoneState = true;
      }
    },
  },
};
</script>

<style>
</style>