<template>
  <div class="publish-steps">
    <StepsComp
      :active="form.active"
      :finish="form.finish"
      :status="form.status"
      :steps="['安装环境', '登录检查', '编译打包']"
    />
    <template v-if="form.active === 0">
      <InstallStatus
        :key="index"
        :data="status"
        @dowload="handleDowload"
        v-for="(status, index) in form.statusItems"
      />
      <div class="handle-btns">
        <el-button :disabled="disabled" type="primary">下一步</el-button>
      </div>
    </template>
    <template v-if="form.active === 1">
      <StepsStatus
        :key="index"
        :data="status"
        @reload="handleReload"
        v-for="(status, index) in form.statusItems"
      />
      <div class="handle-btns">
        <el-button :disabled="disabled" type="primary">下一步</el-button>
      </div>
    </template>
    <template v-if="form.active === 2">
      <StepsStatus
        :key="index"
        :data="status"
        @reload="handleReload"
        v-for="(status, index) in form.statusItems"
      />
      <div class="logs-content">
        <el-collapse>
          <el-collapse-item title="构建日志" name="1">
            <div>
              Consistent with real life: in line with the process and logic of
              real life, and comply with languages and habits that the users are
              used to;
            </div>
          </el-collapse-item>
        </el-collapse>
      </div>
    </template>
  </div>
</template>

<script setup name="PublishSteps">
import { reactive, computed } from "vue";
import StepsComp from "./components/steps-comp.vue";
import StepsStatus from "./components/steps-status.vue";
import InstallStatus from "./components/install-status.vue";

const form = reactive({
  active: 2,
  finish: "process",
  status: "process",
  statusItems: [
    {
      name: "拉取代码",
      finish: false,
      value: "",
      loading: false,
      message: "拉取失败",
    },
    {
      name: "构建应用",
      finish: false,
      value: "",
      loading: false,
      message: "构建失败",
    },
    {
      name: "签名应用",
      finish: false,
      value: "",
      loading: false,
      message: "签名失败",
    },
    {
      name: "上传应用",
      finish: false,
      value: "",
      loading: false,
      message: "上传失败",
    },
    {
      name: "发布版本",
      finish: false,
      value: "",
      loading: false,
      message: "发布版本失败",
    },
    {
      name: "版本审核",
      finish: false,
      value: "",
      loading: false,
      message: "审核失败",
    },
  ],
});

const disabled = computed(() => {
  if (form.active === 0) {
    return !form.statusItems.find((items) => items.finish) ? true : false;
  } else if (form.active === 1) {
    return form.statusItems.find((items) => !items.finish) ? true : false;
  }
  return true;
});

const handleReload = (data) => {
  console.log(data, "handleReload");
};

const handleDowload = (data) => {
  console.log(data, "handleDowload");
};
</script>
<style lang="scss" scoped>
.publish-steps {
  flex: 1;
  .handle-btns,
  .logs-content {
    display: flex;
    align-items: center;
    justify-content: flex-end;
    margin: 30px 10px 0px 10px;
  }

  .logs-content {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;
    .el-collapse {
      flex: 0.95;
    }
  }
}
</style>
