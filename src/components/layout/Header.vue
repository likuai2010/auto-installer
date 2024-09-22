<template>
  <el-header class="header">
    <!-- logo -->
    <div class="logo">
      <img src="../../assets/logo.png" alt="logo" />
    </div>
    <!-- 系统标题 -->
    <div class="title">{{ CONFIG.title }}</div>
    <div class="user-info">
      <!-- 用户名下拉菜单 -->
      <el-dropdown class="user-name" trigger="click" @command="handleCommand">
        <span class="el-dropdown-link">
          {{ username || "用户" }}
          <svg-icon icon="icon-down" />
        </span>
        <template #dropdown>
          <el-dropdown-menu>
            <el-dropdown-item command="setting">用户设置</el-dropdown-item>
            <el-dropdown-item command="security">修改密码</el-dropdown-item>
            <el-dropdown-item command="logout">退出登录</el-dropdown-item>
          </el-dropdown-menu>
        </template>
      </el-dropdown>
    </div>
  </el-header>
</template>
<script setup name="Header">
import CONFIG from "@/config";
import { useStore } from "vuex";

const store = useStore();

const handleCommand = (command) => {
  switch (command) {
    case "setting":
      break;
    case "security":
      break;
    case "logout":
      break;
  }
};
</script>
<style lang="scss" scoped>
.header {
  width: 100%;
  height: 50px;
  display: flex;
  color: #000;
  padding: 0 10px;
  background: #fff;
  border-bottom: 1px solid rgba(114, 114, 114, 0.2);
  .logo {
    float: left;
    cursor: pointer;
    margin-right: 8px;
    line-height: 50px;
    img {
      width: 32px;
      margin: 9px;
      height: 32px;
    }
  }
  .title {
    flex: 0 1 auto;
    font-size: 22px;
    line-height: 50px;
  }

  .user-info {
    display: flex;
    margin-left: auto;

    .user-guide,
    .full-screen {
      font-size: 32px;
      line-height: 50px;
      margin: 0px 5px;
    }
    .user-avatar {
      width: 32px;
      height: 32px;
      margin: 8px;
      border-radius: 50%;
    }
    .user-name {
      cursor: pointer;
      line-height: 50px;
      margin-right: 30px;
    }
  }
}
</style>
