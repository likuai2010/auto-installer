<template>
  <div class="steps-status">
    <div class="title">{{ data?.name }}</div>
    <div class="process">
      <div class="process-items">
        <span :class="['text', data?.finish ? 'finish' : 'error']">{{
          data.value
        }}</span>
      </div>
    </div>
    <div class="status">
      <template v-if="!data?.loading">
        <el-icon v-if="data?.finish"
          ><CircleCheckFilled color="#67C23A" />
        </el-icon>
        <el-icon v-if="!data?.finish"
          ><CircleCloseFilled color="#F56C6C"
        /></el-icon>
      </template>

      <el-button
        link
        @click="handleLoads"
        :loading="data?.loading"
        :disabled="disabled || data?.finish"
        :type="data?.finish ? 'success' : 'primary'"
        >{{ data?.message }}
      </el-button>
    </div>
  </div>
</template>

<script setup name="StepsStatus">
import { defineProps, defineEmits } from "vue";
import { CircleCheckFilled, CircleCloseFilled } from "@element-plus/icons-vue";

const props = defineProps({
  data: {
    type: Object,
    default: () => {
      return {};
    },
  },
  disabled: {
    type: Boolean,
    default: () => {
      return false;
    },
  },
});

const emits = defineEmits(["reload"]);

const handleLoads = () => {
  emits("reload", props.data);
};
</script>
<style lang="scss" scoped>
.steps-status {
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
