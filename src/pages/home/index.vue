<template>
  <div class="page-home">
    <div class="page-home-form">
      <el-form ref="formEl" :model="form" :rules="formRules" label-width="auto">
        <!-- <el-form-item label="GitHub地址：" :prop="['github', 'branch']">
          <el-input
            v-model="form.github"
            :disabled="true"
            @input="getGitHub(value)"
          >
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
        </el-form-item> -->

        <el-form-item label="无线安装："  :prop="['deviceIp']">
          <el-input v-model="form.deviceIp" placeholder="输入ip地址和端口(请在开发者选项里开启手机无线调试功能，并在同一局域网)" />
        </el-form-item>
        <el-form-item label="应用包名：" :prop="['packageName']">
          <el-input v-model="form.packageName" />
        </el-form-item>

        <el-form-item label="构建方式：" :prop="['buildType']">
          <el-radio-group v-model="form.buildType" :disabled="true">
            <el-radio :value="0">分发</el-radio>
            <el-radio :value="1">本地</el-radio>
          </el-radio-group>
        </el-form-item>
        <div class="upload-content">
          <el-upload
            drag
            accept=".hap, .app"
            :auto-upload="false"
            :show-file-list="false"
            :on-change="changeFile"
          >
            <el-icon class="el-icon--upload"><upload-filled /></el-icon>
            <div class="el-upload__text">
              将文件拖放到此处或<em>单击上传</em>
            </div>
          </el-upload>
          <div class="upload-file-list">
            <FileItems
              :key="index"
              :data="items"
              @delete="handleDeleteFile"
              @selected="handleSelectedFile"
              :active="status?.selected?.packageName"
              v-for="(items, index) in hapInfoItems"
            />
          </div>
          <LoadComp
            v-if="status.upload"
            :customStyle="{ position: 'absolute' }"
          />
        </div>
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
      <PublishSteps
        ref="stepsEl"
        :formData="form"
        @update="handleUpdate"
        @on-state-change="onStateChange"
        :buildType="form.buildType"
      />
    </div>
    <el-divider />
    <div class="page-home-status">
      <el-form :model="form" label-width="auto">
        <el-form-item label="超大hap文件">
            <el-input v-model="status.dowloadUrl">
              <template #append>
                <el-tooltip effect="light" placement="top" content="点击选择文件">
                  <el-button :icon="CopyDocument"  @click="openBigHap"/>
                </el-tooltip>
              </template>
            </el-input>
          </el-form-item>
      </el-form>
    </div>
    <PacketPhone></PacketPhone>
  </div>
</template>

<script setup name="HomePage">
import { ref, reactive } from "vue";
import { ElNotification } from "element-plus";
import LoadComp from "@/components/loading/index.vue";
import FileItems from "@/components/file-items/index.vue";
import PublishSteps from "@/components/publish-steps/index.vue";
import PacketPhone from "@/components/packet-phone/index.vue";
import {
  CopyDocument,
  UploadFilled,
  CircleCloseFilled,
} from "@element-plus/icons-vue";

const formEl = ref(null); //form表单Dom
const stepsEl = ref(null); //构建步骤Dom
const loading = ref(false); //获取git分支loading状态
const branchItems = ref([]); //获取git分支集合
const hapInfoItems = ref([]); //上传文件List

const form = reactive({
  github: "", //github地址
  branch: "", //git分支
  appName: "", //应用名称
  packageName: "", //包名称
  deviceIp: "", //设备IP
  hapPath: "", //包路
  buildType: 1, //构建方式 0:分发,1:本地
});

const status = reactive({
  active: -1, //构建步骤
  upload: false, //文件上传loading状态
  loading: false, //开始构建loading状态
  disabled: true, //开始构建disabled状态
  dowloadUrl: "", //bighapfilePath
  statusItems: [], //构建步骤完成子状态
  selected: null, //当前选择上传文件
});

const formRules = reactive({
  github: [{ required: true, message: "Git地址不允许为空", trigger: "blur" }],
  branch: [{ required: true, message: "分支名称不允许为空", trigger: "blur" }],
  appName: [{ required: true, message: "应用名称不允许为空", trigger: "blur" }],
  deviceIp: [{ required: false, message: "设备IP不允许为空", trigger: "blur" }],
  buildType: [
    { required: true, message: "构建方式不允许为空", trigger: "change" },
  ],
  packageName: [
    { required: true, message: "应用包名不允许为空", trigger: "blur" },
  ],
});

const getGitHub = (url) => {
  loading.value = true;
  url = "https://github.com/likuai2010/testgo.git";
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
const openBigHap = () =>{
  window.CoreApi.openBigHap().then(( hapInfo)=>{
    status.dowloadUrl = hapInfo.hapPath
    form.appName = hapInfo.appName; //app名称
    form.hapPath = hapInfo.hapPath; //包文件路径
    form.packageName = hapInfo.packageName; // 包名称
    status.upload = false;
    status.disabled = false;
    status.selected = {
      hapInfo,
      form: { ...form },
      packageName: hapInfo.packageName,
    };
    const hapindex = hapInfoItems.value.findIndex(f=>f.packageName == hapInfo.packageName)
    if(hapindex > -1){
      hapInfoItems.value[hapindex] = status.selected;
    }else{
      hapInfoItems.value.push(status.selected);
    }
  })
}
const changeFile = async (file) => {
  status.upload = true;
  status.disabled = true;
  let hapInfo = await window.CoreApi.uploadHap(file);
  form.appName = hapInfo.appName; //app名称
  form.hapPath = hapInfo.hapPath; //包文件路径
  form.packageName = hapInfo.packageName; // 包名称
  status.upload = false;
  status.disabled = false;
  status.selected = {
    hapInfo,
    form: { ...form },
    packageName: hapInfo.packageName,
  };
  const hapindex = hapInfoItems.value.findIndex(f=>f.packageName == hapInfo.packageName)
  if(hapindex > -1){
    hapInfoItems.value[hapindex] = status.selected;
  }else{
    hapInfoItems.value.push(status.selected);
  }
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
  status.active = form.active;
  status.statusItems = form.statusItems;
};
const onStateChange = (result) =>{
  debugger
  status.disabled = result;
}

const handleDeleteFile = (data) => {
  if (status.selected.packageName === data.packageName) {
    ElNotification({
      title: "提示",
      type: "warning",
      message: "当前包已选中无法删除!",
    });
  } else {
    hapInfoItems.value = hapInfoItems.value.filter(
      (items) => items.packageName !== data.packageName
    );
  }
};

const handleSelectedFile = (data) => {
  status.selected = data;
  form.github = data.form?.github || ""; //github地址
  form.branch = data.form?.branch || ""; //git分支
  form.appName = data.form?.appName || ""; //应用名称
  form.packageName = data?.form.packageName || ""; //包名称
  form.deviceIp = data.form?.deviceIp || ""; //设备IP
  form.hapPath = data.form?.hapPath || ""; //包路
  form.buildType = data.form?.buildType || 0; //构建方式 0:分发,1:本地
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
      .upload-content {
        position: relative;
        .upload-file-list {
          width: 100%;
          display: flex;
          flex-wrap: wrap;
          margin: 10px 0px;
          justify-content: flex-start;
        }
      }
    }
  }
}
</style>
