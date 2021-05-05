<template>
  <input v-model="textModel" v-on:input="editChange" />
</template>

<script>
export default {
  props: {
    text: String,
  },
  data() {
    return {
      textModel: '',
    };
  },
  created() {
      this.textModel = this.text
  },
  methods: {
    editChange() {
      console.log(this.textModel);
    },
  },
};
</script>

<style>
</style>