<template>
  <div class="page-home">
    <div class="page-home-form">
      <el-form ref="formEl" :model="form" :rules="formRules" label-width="auto">
        <el-form-item label="GitHub地址：" :prop="['github', 'branch']">
          <el-input v-model="form.github" @input="getGitHub(value)">
            <template #append>
              <el-select
                :loading="loading"
                placeholder="选择分支"
                v-model="form.branch"
                :style="{ width: '120px' }"
              >
                <el-option
                  v-for="(item, index) in branchItems"
                  :key="index"
                  :label="item.label"
                  :value="item.value"
                />
              </el-select>
            </template>
          </el-input>
        </el-form-item>
        <el-form-item label="应用名称：" :prop="['appName']">
          <el-input v-model="form.appName" />
        </el-form-item>
        <el-form-item label="应用包名：" :prop="['packageName']">
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
      <PublishSteps ref="stepsEl" :formData="form" @update="handleUpdate" />
    </div>
    <el-divider />
    <div class="page-home-status">
      <el-form :model="form" label-width="auto">
        <template v-if="status.active === 2">
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
        <!-- <template v-if="status.active === 1 && status.installHup"> -->
        <template v-if="status.active === 1">
          <el-upload
            drag
            action="https://run.mocky.io/v3/9d059bf9-4660-45f2-925d-ce80ad6c4d15"
            multiple
          >
            <el-icon class="el-icon--upload"><upload-filled /></el-icon>
            <div class="el-upload__text">
              将文件拖放到此处或<em>单击上传</em>
            </div>
          </el-upload>
        </template>
      </el-form>
    </div>
  </div>
</template>

<script setup name="HomePage">
import { ref, reactive } from "vue";
import PublishSteps from "@/components/publish-steps/index.vue";
import { CopyDocument, UploadFilled } from "@element-plus/icons-vue";

const formEl = ref(null);
const stepsEl = ref(null);
const loading = ref(false);
const branchItems = ref([]);
const form = reactive({
  github: "",
  appName: "",
  packageName: "",
  branch: "",
});

const status = reactive({
  icon: "success",
  active: -1,
  types: 0,
  loading: false,
  disabled: false,
  installHup: false,
  statusItems: [],
  subTitle: "正在进行机器审核中",
  dowloadUrl: "www.baidu.com",
});

const formRules = reactive({
  github: [{ required: true, message: "Git地址不允许为空", trigger: "blur" }],
  branch: [{ required: true, message: "分支名称不允许为空", trigger: "blur" }],
  appName: [{ required: true, message: "应用名称不允许为空", trigger: "blur" }],
  packageName: [
    { required: true, message: "应用包名不允许为空", trigger: "blur" },
  ],
});
const getGitHub = (url) => {
  loading.value = true;
  url = "https://gitee.com/zkaibycode/anything-llm.git";
  form.github = url;
  let name = url.split("/")[url.split("/").length - 1].replace(".git", "");
  form.appName = name.replace("-", "_");
  form.packageName = `com.xiaobai.${name.replace("-", "_")}`;
  window.CoreApi.githubBranchs(url).then((data) => {
    branchItems.value = (data || [])
      .filter((items) => items && items !== "")
      .map((items) => {
        let branchArr = items.split("/");
        let branch = branchArr[branchArr.length - 1];
        return { label: branch, value: branch };
      });
    if (branchItems.value.length) form.branch = branchItems.value[0]?.value;
    loading.value = false;
  });
};

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

const handleUpdate = (form) => {
  status.types = form.types;
  status.active = form.active;
  status.installHup = form.installHup;
  status.statusItems = form.statusItems;
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
