<template v-slot>
  <el-row :gutter="10">
    <el-col :xs="left" :sm="left" :md="left" :lg="left" :xl="left">
      <div v-on:click="translateRight">
        <slot></slot>
      </div>
    </el-col>
    <el-col :xs="right" :sm="right" :md="right" :lg="right" :xl="right">
      <div
        class="grid-content bg-purple-light"
        v-on:click="translateLeft"
      ></div>
    </el-col>
  </el-row>
</template>

<script>
export default {
  data() {
    return {
      left: 23,
      right: 1,
    };
  },
  methods: {
    translateLeft() {
      this.left = 15;
      this.right = 9;
      console.log(this.left, this.right);
    },
    translateRight() {
      this.left = 23;
      this.right = 1;
    },
  },
};
</script>

<style>
.el-col {
  border-radius: 4px;
}
.bg-purple-dark {
  background: #99a9bf;
}
.bg-purple {
  background: #d3dce6;
}
.bg-purple-light {
  background: #e5e9f2;
}
.grid-content {
  border-radius: 4px;
  min-height: 36px;
}
</style>