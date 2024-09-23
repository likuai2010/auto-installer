<template>
  <el-header class="header">
    <div class="header-left">
      <!-- logo -->
      <img src="../../assets/logo.png" alt="logo" />
      <!-- 系统标题 -->
      <div class="title">{{ CONFIG.title }}</div>
    </div>
    <div class="header-right">
      <!-- 用户信息 -->
      <el-dropdown class="user-name" @command="handleCommand">
        <span class="el-dropdown-link">
          <el-icon>
            <user-filled />
          </el-icon>
          {{ username || "用户" }}
          <el-icon>
            <arrow-down />
          </el-icon>
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
import { ArrowDown, UserFilled } from "@element-plus/icons-vue";

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
const onLogin = () => {
  window.Api.toLogin();
  const childWindow = window.open(
    "https://github.com",
    "_blank",
    "top=500,left=200,frame=true,nodeIntegration=no"
  );
  setTimeout(() => {
    const cookies = childWindow.document.cookie;
    console.log("Cookies from child window:", cookies);
  }, 3000);
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
  align-items: center;
  justify-content: space-between;
  box-shadow: 0 4px 10px #4e59690f;
  .header-left {
    display: flex;
    align-items: center;
    justify-content: flex-start;
    img {
      width: 28px;
      height: 28px;
    }
    .title {
      font-size: 24px;
      margin-left: 8px;
      line-height: 28px;
    }
  }

  .header-right {
    margin-right: 10px;
    .user-name {
      display: flex;
      align-items: center;
      justify-content: flex-end;
      .el-dropdown-link {
        display: flex;
        cursor: pointer;
        align-items: center;
        justify-content: space-around;

        :deep(.el-icon) {
          margin: 0px 4px;
        }
      }
    }
  }
}
</style>
