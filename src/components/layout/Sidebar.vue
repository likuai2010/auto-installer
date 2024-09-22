<template>
  <div class="sidebar">
    <div class="sidebar-menu">
      <el-menu
        unique-opened
        :collapse="collapse"
        class="sidebar-el-menu"
        :default-active="onRoutes"
        active-text-color="#20a0ff"
      >
        <template v-for="(items, index) in menuItems" :key="index">
          <template v-if="items.children && items.children.length > 0">
            <el-sub-menu :key="items.name" :index="items.name">
              <template #title>
                <svg-icon :icon="items.meta.icon" />
                <span>{{ items.meta.title }}</span>
              </template>
              <template v-for="subItem in items.children" :key="subItem.name">
                <el-sub-menu v-if="subItem.children" :index="subItem.name">
                  <template #title> <svg-icon :icon="items.meta.icon" />{{ subItem.meta.title }}</template>
                  <el-menu-item
                    v-for="threeItem in subItem.children"
                    :key="threeItem.name"
                    :index="threeItem.name"
                    @click="handlerMenu(threeItem)"
                  >
                    {{ threeItem.meta.title }}</el-menu-item
                  >
                </el-sub-menu>
                <template v-else>
                  <el-menu-item :index="subItem.name" @click="handlerMenu(subItem)">
                    <svg-icon :icon="items.meta.icon" />
                    {{ subItem.meta.title }}
                  </el-menu-item>
                </template>
              </template>
            </el-sub-menu>
          </template>
          <template v-else>
            <el-menu-item :key="items.name" :index="items.name" @click="handlerMenu(items)">
              <svg-icon :icon="items.meta.icon" />
              <template #title>{{ items.meta.title }}</template>
            </el-menu-item>
          </template>
        </template>
      </el-menu>
    </div>
    <!-- 折叠按钮 -->
    <div class="sidebar-collapse" @click="collapseChage">
      <svg-icon :icon="!collapse ? 'icon-control-expand' : 'icon-control-collapse'" />
    </div>
  </div>
</template>
<script setup name="Sidebar">
import { computed } from 'vue'
import { useStore } from 'vuex'
import { useRoute, useRouter } from 'vue-router'

const store = useStore()
const route = useRoute()
const router = useRouter()

const onRoutes = computed(() => route.name)
const collapse = computed(() => store.state.app.collapse)

const menuItems = computed(() => {
  let routes = router.options.routes
  let { children } = routes.find(({ name }) => name === 'layout') || {}
  return children && children.length > 0 ? children : []
})

const collapseChage = () => {
  store.commit('app/setCollapse', !collapse.value)
}

const handlerMenu = (item) => {
  store.commit('app/setMenu', item)
  router.push({ name: item.name })
}
</script>
<style lang="scss" scoped>
.sidebar {
  width: auto;
  height: 100%;
  overflow: hidden;
  border-right: solid 1px #dcdfe6;
  .sidebar-menu {
    overflow: hidden;
    overflow-y: auto;
    height: calc(100% - 32px);

    :deep(.el-menu) {
      height: 100%;
      border: none;
    }

    ul {
      height: 100%;
    }

    ul li .svg-icon {
      font-size: 24px;
    }

    .sidebar-el-menu:not(.el-menu--collapse) {
      width: 200px;
    }
  }
  .sidebar-collapse {
    height: 24px;
    display: flex;
    align-items: center;
    justify-content: center;
    .svg-icon {
      font-size: 24px;
    }
  }
  .sidebar-menu::-webkit-scrollbar {
    width: 0;
  }
}
</style>
