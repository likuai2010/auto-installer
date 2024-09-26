<template>
  <div class="install-status">
    <div class="title">{{ data?.name }}</div>
    <div class="process">
      <div v-if="status.dowload" class="process-items">
        <el-progress
          striped
          striped-flow
          :duration="1"
          :stroke-width="8"
          :percentage="status.process"
          :format="(percentage) => `${percentage}%`"
        ></el-progress>

        <el-button
          link
          type="primary"
          @click="handleInstall"
          :disabled="status.process < 100"
          >安装
        </el-button>
      </div>
      <div v-if="!status.dowload" class="process-items">
        <span :class="['text', data?.finish ? 'finish' : 'error']">{{
          data.value
        }}</span>
        <template v-if="!data?.finish">
          <el-button type="primary" link @click="handleDowload"
            >下载
          </el-button>
        </template>
      </div>
    </div>
    <div class="status">
      <el-icon v-if="data?.finish"
        ><CircleCheckFilled color="#67C23A" />
      </el-icon>
      <el-icon v-if="!data?.finish"
        ><CircleCloseFilled color="#F56C6C"
      /></el-icon>
      <span :class="['text', data?.finish ? 'finish' : 'error']">{{
        data?.message
      }}</span>
    </div>
  </div>
</template>

<script setup name="InstallStatus">
import { reactive, defineProps } from "vue";
import { ElNotification } from "element-plus";
import { CircleCheckFilled, CircleCloseFilled } from "@element-plus/icons-vue";

let timer = null;
const props = defineProps({
  data: {
    type: Object,
    default: () => {
      return {};
    },
  },
});
const status = reactive({
  process: 0,
  dowload: false,
});

const clearTimer = () => {
  if (timer) {
    clearInterval(timer);
    timer = null;
  }
};

const dowloadTimer = () => {
  clearTimer();
  timer = setInterval(() => {
    if (status.process >= 100) {
      clearTimer();
    } else {
      status.process += 1;
    }
  }, 200);
};

const emits = defineEmits(["install", "dowload"]);

const handleDowload = () => {
  if (props.data.url) {
    status.dowload = true;
    window.CoreApi.downloadAndInstaller(
      props.data.url,
      (process) => (status.process = Number((process * 100).toFixed(1)))
    );
  } else {
    ElNotification({
      title: "提示",
      message: "未获取到下载地址",
    });
  }
};

const handleInstall = () => {
  emits("install", props.data);
};
</script>
<style lang="scss" scoped>
.install-status {
  flex: 1;
  display: flex;
  margin: 8px 4%;
  font-size: 14px;
  align-items: center;
  justify-content: flex-start;

  .text {
    margin-left: 4px;
  }

  .finish {
    color: #67c23a;
  }
  .error {
    color: #f56c6c;
  }
  .title {
    flex: 0.15;
  }
  .process {
    flex: 0.75;
    .process-items {
      display: flex;
      align-items: center;
      justify-content: space-between;
      .el-progress {
        flex: 0.95;
      }
    }
  }
  .status {
    flex: 0.1;
    display: flex;
    align-items: center;
    justify-content: flex-end;
  }
}
</style>
