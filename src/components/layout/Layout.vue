<template>
  <div id="layout" class="layout">
    <Header />
    <div class="content-container">
      <!-- <SideBar /> -->
      <div class="main-container">
        <div v-if="loaded" v-loading="loading" class="view-container">
          <router-view />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup name="Layout">
import { computed } from "vue";
import { useStore } from "vuex";
import Header from "@/components/layout/Header.vue";
import SideBar from "@/components/layout/Sidebar.vue";

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
    height: calc(100% - 50px);
    display: flex;
  }
  .main-container {
    box-sizing: border-box;
    width: 0;
    padding: 10px 20px 20px;
    flex: 1 1 auto;
    display: flex;
    flex-direction: column;
  }
  .view-container {
    margin-top: 10px;
    flex: 1 1 100%;
    overflow: auto;
  }
}
</style>
