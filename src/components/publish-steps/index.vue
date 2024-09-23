<template>
  <div class="publish-steps">
    <el-steps
      simple
      :active="active"
      :finish-status="finishStatus"
      :process-status="processStatus"
    >
      <el-step title="环境检查">
        <template #icon>
          <Loading color="#909399" v-if="processStatus === 'wait'" />
          <Finished color="#67C23A" v-if="processStatus === 'finish'" />
          <InfoFilled color="#909399" v-if="processStatus === 'process'" />
          <SuccessFilled color="#409EFF" v-if="processStatus === 'success'" />
          <CircleCloseFilled color="#F56C6C" v-if="processStatus === 'error'" />
        </template>
        <template #default> </template>
      </el-step>
      <el-step title="账号登录">
        <template #icon>
          <Loading color="#909399" v-if="processStatus === 'wait'" />
          <Finished color="#67C23A" v-if="processStatus === 'finish'" />
          <InfoFilled color="#909399" v-if="processStatus === 'process'" />
          <SuccessFilled color="#409EFF" v-if="processStatus === 'success'" />
          <CircleCloseFilled color="#F56C6C" v-if="processStatus === 'error'" />
        </template>
      </el-step>
      <el-step title="构建状态">
        <template #icon>
          <Loading color="#909399" v-if="processStatus === 'wait'" />
          <Finished color="#67C23A" v-if="processStatus === 'finish'" />
          <InfoFilled color="#909399" v-if="processStatus === 'process'" />
          <SuccessFilled color="#409EFF" v-if="processStatus === 'success'" />
          <CircleCloseFilled color="#F56C6C" v-if="processStatus === 'error'" />
        </template>
      </el-step>
    </el-steps>

    <template v-if="active === 2">
      <div class="progress-content">
        <div class="title">构建进度：</div>
        <div class="progress">
          <el-progress
            status="success"
            :stroke-width="18"
            :text-inside="true"
            :percentage="percentage"
          >
            <span>{{ `${percentage}%` }}</span>
          </el-progress>
        </div>
      </div>
      <el-collapse>
        <el-collapse-item title="构建日志" name="1">
          <div class="build-logs">
            {{ buildLogs }}
          </div>
        </el-collapse-item>
      </el-collapse>
    </template>
  </div>
</template>

<script setup name="PublishSteps">
import { defineProps } from "vue";
import {
  Loading,
  Finished,
  InfoFilled,
  SuccessFilled,
  CircleCloseFilled,
} from "@element-plus/icons-vue";

// "wait", "process", "finish", "error", "success"
const props = defineProps({
  active: {
    type: Number,
    default: 2,
  },
  buildLogs: {
    type: String,
    default: () => "",
  },
  percentage: {
    type: Number,
    default: () => 0,
  },
  finishStatus: {
    type: String,
    default: () => "finish",
  },
  processStatus: {
    type: String,
    default: () => "process",
  },
});
</script>
<style lang="scss" scoped>
.publish-steps {
  width: 100%;
  .progress-content {
    width: 100%;
    display: flex;
    margin: 20px 0px;
    align-items: center;
    justify-content: flex-start;
    .title {
      width: 80px;
      color: var(--el-text-color-regular);
      font-size: var(--el-form-label-font-size);
    }
    .progress {
      width: calc(100% - 80px);
    }

    .build-logs {
    }
  }
}
</style>
