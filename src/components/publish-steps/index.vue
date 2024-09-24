<template>
  <div class="publish-steps">
    <el-steps
      simple
      :active="active"
      :finish-status="stepForm.finishStatus"
      :process-status="stepForm.processStatus"
    >
      <el-step title="环境检查">
        <template #icon>
          <Loading color="#909399" v-if="stepForm.processStatus === 'wait'" />
          <Finished
            color="#67C23A"
            v-if="stepForm.processStatus === 'finish'"
          />
          <InfoFilled
            color="#909399"
            v-if="stepForm.processStatus === 'process'"
          />
          <SuccessFilled
            color="#409EFF"
            v-if="stepForm.processStatus === 'success'"
          />
          <CircleCloseFilled
            color="#F56C6C"
            v-if="stepForm.processStatus === 'error'"
          />
        </template>
      </el-step>
      <el-step title="账号登录">
        <template #icon>
          <Loading color="#909399" v-if="stepForm.processStatus === 'wait'" />
          <Finished
            color="#67C23A"
            v-if="stepForm.processStatus === 'finish'"
          />
          <InfoFilled
            color="#909399"
            v-if="stepForm.processStatus === 'process'"
          />
          <SuccessFilled
            color="#409EFF"
            v-if="stepForm.processStatus === 'success'"
          />
          <CircleCloseFilled
            color="#F56C6C"
            v-if="stepForm.processStatus === 'error'"
          />
        </template>
      </el-step>
      <el-step title="构建状态">
        <template #icon>
          <Loading color="#909399" v-if="stepForm.processStatus === 'wait'" />
          <Finished
            color="#67C23A"
            v-if="stepForm.processStatus === 'finish'"
          />
          <InfoFilled
            color="#909399"
            v-if="stepForm.processStatus === 'process'"
          />
          <SuccessFilled
            color="#409EFF"
            v-if="stepForm.processStatus === 'success'"
          />
          <CircleCloseFilled
            color="#F56C6C"
            v-if="stepForm.processStatus === 'error'"
          />
        </template>
      </el-step>
    </el-steps>
    <template v-if="active === 0">
      <div class="env-progress-content">
        <div
          v-for="(data, index) in dataItems"
          :key="index"
          class="content-items"
        >
          <div class="title">{{ data?.name }}</div>
          <div class="progress-content">
            <el-progress
              status="success"
              :stroke-width="20"
              :text-inside="true"
              :percentage="data?.progress"
            >
              <span>{{ `当前下载${data?.progress}%` }}</span>
            </el-progress>
          </div>
          <div class="btns-content">
            <el-tooltip
              v-if="data?.finish"
              effect="light"
              content="已安装"
              placement="top"
            >
              <el-icon>
                <el-icon><SuccessFilled color="#67C23A" /></el-icon>
              </el-icon>
            </el-tooltip>

            <el-tooltip
              v-if="!data?.finish"
              effect="light"
              content="下载"
              placement="top"
            >
              <el-icon>
                <Download color="#409EFF" />
              </el-icon>
            </el-tooltip>
          </div>
        </div>
        <div class="content-btns">
          <el-button :disabled="disabled" type="primary">下一步</el-button>
        </div>
      </div>
    </template>
    <template v-if="active === 1">
      <div class="login-progress-content">
        <div
          v-for="(data, index) in dataItems"
          :key="index"
          class="content-items"
        >
          <div class="title">{{ data?.name }}</div>
          <div class="progress-content">
            {{ data?.value }}
          </div>
          <div class="btns-content">
            <el-icon v-if="data?.finish">
              <el-icon><Finished color="#67C23A" /></el-icon>
            </el-icon>
            <el-icon v-if="!data?.finish">
              <el-icon><CircleCloseFilled color="#F56C6C" /></el-icon>
            </el-icon>
          </div>
        </div>
        <div class="content-btns">
          <el-button :disabled="disabled" type="primary">下一步</el-button>
        </div>
      </div>
    </template>
    <template v-if="active === 2">
      <div class="login-progress-content">
        <div
          v-for="(data, index) in dataItems"
          :key="index"
          class="content-items"
        >
          <div class="title">{{ data?.name }}</div>
          <div class="progress-content">
            {{ data?.value }}
          </div>
          <div class="btns-content">
            <el-icon v-if="data?.finish">
              <el-icon><Finished color="#67C23A" /></el-icon>
            </el-icon>
            <el-icon v-if="!data?.finish">
              <el-icon><CircleCloseFilled color="#F56C6C" /></el-icon>
            </el-icon>
          </div>
        </div>
        <el-collapse>
          <el-collapse-item title="构建日志" name="1">
            <div class="build-logs">
              {{ buildLogs }}
            </div>
          </el-collapse-item>
        </el-collapse>
      </div>
    </template>
  </div>
</template>

<script setup name="PublishSteps">
import { reactive, computed, defineProps } from "vue";
import {
  Check,
  Loading,
  Finished,
  Download,
  UserFilled,
  InfoFilled,
  SuccessFilled,
  CircleCloseFilled,
} from "@element-plus/icons-vue";

// "wait", "process", "finish", "error", "success"
const props = defineProps({
  active: {
    type: Number,
    default: 1,
  },
  dataItems: {
    type: Array,
    default: () => {
      return [
        // { name: "安装docker", finish: false, progress: 10 },
        // { name: "命令行工具", finish: false, progress: 20 },

        { name: "登陆华为账号", finish: false, value: "" },
        { name: "ClientID", finish: false, value: "" },
        { name: "ClientKey", finish: false, value: "" },
        { name: "创建应用", finish: false, value: "" },
      ];
    },
  },
});

const disabled = computed(() => {
  return !props.dataItems.find((items) => items.finish);
});

const stepForm = reactive({
  finishStatus: "finish",
  processStatus: "process",
});
</script>
<style lang="scss" scoped>
.publish-steps {
  width: 100%;
  .login-progress-content,
  .build-progress-content,
  .env-progress-content {
    width: 90%;
    margin: 0px 5%;
    align-items: center;
    flex-direction: column;
    .content-items {
      display: flex;
      margin: 20px 0px;
      align-items: center;
      justify-content: space-around;
      .title {
        width: 100px;
        color: var(--el-text-color-regular);
        font-size: var(--el-form-label-font-size);
      }
      .btns-content {
        display: flex;
        align-items: center;
        :deep(.el-icon) {
          cursor: pointer;
        }
      }
      .progress-content {
        width: calc(100% - 150px);
        color: var(--el-text-color-regular);
        font-size: var(--el-form-label-font-size);
      }
    }

    .content-btns {
      width: 100%;
      display: flex;
      justify-content: flex-end;
    }
  }
}
</style>
