<template>
  <div id="layout" class="layout">
    <Header />
    <div class="content-container">
      <div v-if="loaded" v-loading="loading" class="view-container">
        <router-view />
      </div>
    </div>
  </div>
</template>

<script setup name="Layout">
import { computed } from "vue";
import { useStore } from "vuex";
import Header from "@/components/layout/Header.vue";

const store = useStore();
const loading = computed(() => store.state.app.loading);
const loaded = computed(() => store.state.app.loaded);
</script>

<style lang="scss" scoped>
.layout {
  width: 100%;
  height: 100%;
  box-sizing: border-box;
  .content-container {
    display: flex;
    flex: 1 1 auto;
    overflow: auto;
    height: calc(100% - 50px);
    box-sizing: border-box;
    padding: 10px 20px 20px;
    flex-direction: column;
  }
}
</style>
