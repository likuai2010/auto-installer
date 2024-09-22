<template>
  <el-header class="header">
    <!-- logo -->
    <div class="logo">
      <img src="../../assets/logo.png" alt="logo" />
    </div>
    <!-- 系统标题 -->
    <div class="title">{{ CONFIG.title }}</div>

    <div class="user-info">
      <div class="contact-us">
        <el-icon><Phone /></el-icon>
        联系我们
      </div>
      <div class="reward">
        <el-icon><Money /></el-icon>打赏
      </div>

      <!-- 用户名下拉菜单 -->
      <el-dropdown class="user-name" trigger="click" @command="handleCommand">
        <span class="el-dropdown-link">
          <el-icon><UserFilled /></el-icon>
          <span class="user">{{ username || "用户" }}</span>
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
import { UserFilled, Phone, Money } from "@element-plus/icons-vue";

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

    .reward,
    .contact-us {
      display: flex;
      font-size: 14px;
      cursor: pointer;
      align-items: center;
      line-height: 50px;
      margin-right: 15px;
      color: var(--color);
      .el-icon {
        margin-right: 5px;
      }
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
      .el-dropdown-link {
        display: flex;
        align-items: center;
        justify-content: space-around;

        .user {
          cursor: pointer;
          font-size: 14px;
          color: var(--color);
        }

        .el-icon {
          margin-right: 5px;
        }
        .svg-icon {
          margin-left: 5px;
        }
      }
    }
  }
}
</style>
