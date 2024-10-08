<template>
  <div class="loading" :style="customStyle">
    <img src="../../assets/images/loading.gif" />
  </div>
</template>

<script setup name="Loading">
import { defineProps } from "vue";

defineProps({
  customStyle: {
    type: Object,
    default: () => {
      return {};
    },
  },
});
</script>

<style lang="scss" scoped>
.loading {
  position: fixed;
  top: 0px;
  left: 0px;
  z-index: 9999;
  width: 100%;
  height: 100%;
  background: rgba(255, 255, 255, 0.8);
  display: flex;
  align-items: center;
  justify-content: center;
  img {
    width: 48px;
    height: 48px;
  }
}
</style>
