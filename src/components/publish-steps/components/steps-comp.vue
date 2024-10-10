<template>
  <div class="steps-comp">
    <el-steps
      simple
      :active="active"
      :finish-status="finish"
      :process-status="status"
    >
      <template v-for="(step, index) in steps" :key="index">
        <el-step :title="step">
          <template #icon>
            <Loading color="#909399" v-if="status === 'wait'" />
            <Finished color="#67C23A" v-if="status === 'finish'" />
            <InfoFilled color="#909399" v-if="status === 'process'" />
            <SuccessFilled color="#409EFF" v-if="status === 'success'" />
            <CircleCloseFilled color="#F56C6C" v-if="status === 'error'" />
          </template>
        </el-step>
      </template>
    </el-steps>
  </div>
</template>

<script setup name="StepsComp">
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
    default: () => 0,
  },
  steps: {
    type: Array,
    default: () => ["环境检查", "登录检查", "编译打包"],
  },
  finish: {
    type: String,
    default: () => "process",
  },
  status: {
    type: String,
    default: () => "process",
  },
});
</script>
<style lang="scss" scoped>
.steps-comp {
  flex: 1;
}
</style>
