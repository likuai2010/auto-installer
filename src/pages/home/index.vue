<template>
  <div class="page-home">
    <div class="page-home-form">
      <el-form ref="formEl" :model="form" :rules="rules" label-width="auto">
        <el-form-item label="GitHub地址：" prop="gitUrls">
          <el-input v-model="form.gitUrls" />
          <div class="desc-text">仅支持 HarmonyOS Next 应用</div>
        </el-form-item>
        <el-form-item label="应用名称：" prop="appName">
          <el-input v-model="form.appName" />
        </el-form-item>
        <el-form-item label="应用包名：" prop="packageName">
          <el-input v-model="form.packageName" />
        </el-form-item>
        <div class="btns-content">
          <el-button type="primary" @click="submitForm">开始构建</el-button>
        </div>
      </el-form>
    </div>
    <el-divider />
    <div class="page-home-steps">
      <PublishSteps />
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
              <el-input disabled v-model="status.dowloadUrl">
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
    <PacketPhone />
  </div>
</template>

<script setup name="HomePage">
import { ref, reactive } from "vue";
import { CopyDocument } from "@element-plus/icons-vue";
import PacketPhone from "@/components/packet-phone/index.vue";
import PublishSteps from "@/components/publish-steps/index.vue";

const formEl = ref(null);
const rules = reactive({
  appName: [{ required: true, message: "应用名称不允许为空", trigger: "blur" }],
  gitUrls: [
    { required: true, message: "GitHub地址不允许为空", trigger: "blur" },
  ],
  packageName: [
    { required: true, message: "应用包名不允许为空", trigger: "blur" },
  ],
});
const form = reactive({ appName: "", gitUrls: "", packageName: "" });
const status = reactive({
  icon: "success",
  subTitle: "正在进行机器审核中",
  dowloadUrl: "www.baidu.com",
});

const submitForm = async () => {
  if (!formEl.value) return;
  await formEl.value.validate((valid, fields) => {
    if (valid) {
      console.log("submit!");
      // window.Api.toLogin();
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
      .desc-text {
        width: 100%;
        text-align: right;
        font-size: 12px;
        left: 0;
        top: 100%;
        line-height: 1;
        padding-top: 2px;
        position: absolute;
        color: var(--el-color-danger);
      }
      .btns-content {
        display: flex;
        align-items: center;
        justify-content: flex-end;
      }
    }
  }
}
</style>
