<template>
  <div class="page-home">
    <div class="page-home-form">
      <el-form ref="formEl" :model="form" label-width="auto">
        <el-form-item label="GitHub地址：">
          <el-input v-model="form.gitUrls" />
        </el-form-item>
        <el-form-item label="应用名称：">
          <el-input v-model="form.appName" />
        </el-form-item>
        <el-form-item label="应用包名：">
          <el-input v-model="form.packageName" />
        </el-form-item>
        <div class="btns-content">
          <el-button
            type="primary"
            @click="submitForm"
            :loading="status.loading"
            :disabled="status.disabled"
            >开始构建</el-button
          >
        </div>
      </el-form>
    </div>
    <el-divider />
    <div class="page-home-steps">
      <PublishSteps ref="stepsEl" />
    </div>
    <el-divider />
    <div class="page-home-status">
      <el-form :model="form" label-width="auto">
        <el-result
          title="审核状态"
          :icon="status.icon"
          :sub-title="status.subTitle"
        >
          <template #extra>
            <el-form-item label="下载地址：">
              <el-input v-model="status.dowloadUrl">
                <template #append>
                  <el-tooltip effect="light" placement="top" content="复制">
                    <el-button :icon="CopyDocument" />
                  </el-tooltip>
                </template>
              </el-input>
            </el-form-item>
          </template>
        </el-result>
      </el-form>
    </div>
  </div>
</template>

<script setup name="HomePage">
import { ref, reactive } from "vue";
import { CopyDocument } from "@element-plus/icons-vue";
import PublishSteps from "@/components/publish-steps/index.vue";

const formEl = ref(null);
const stepsEl = ref(null);
const form = reactive({ appName: "", gitUrls: "", packageName: "" });
const status = reactive({
  icon: "success",
  loading: false,
  disabled: false,
  subTitle: "正在进行机器审核中",
  dowloadUrl: "www.baidu.com",
});

const submitForm = async () => {
  if (!formEl.value) return;
  await formEl.value.validate((valid, fields) => {
    if (valid) {
      status.loading = true;
      setTimeout(() => {
        stepsEl.value.initPublishSteps(0);
        status.loading = false;
        status.disabled = true;
      });
    } else {
      console.log("error submit!", fields);
    }
  });
};
</script>

<style lang="scss" scoped>
.page-home {
  height: 100%;
  display: flex;
  padding: 20px 100px;
  align-items: center;
  flex-direction: column;
  justify-content: flex-start;

  .page-home-form,
  .page-home-steps,
  .page-home-status {
    width: 80%;
    :deep(.el-form),
    :deep(.el-result__extra) {
      width: 100%;
      .btns-content {
        display: flex;
        align-items: center;
        justify-content: flex-end;
      }
    }
  }
}
</style>
