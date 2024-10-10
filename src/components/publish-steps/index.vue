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
        v-for="(status, index) in form.statusItems"
      />
      <div class="handle-btns">
        <el-button :disabled="disabled" type="primary" @click="handleNext(1)"
          >下一步</el-button
        >
      </div>
    </template>
    <template v-if="form.active === 1">
      <StepsStatus
        :key="index"
        :data="status"
        :disabled="true"
        @reload="handleReload"
        v-for="(status, index) in form.statusItems"
      />
      <div class="handle-btns">
        <el-button :disabled="disabled" type="primary" @click="handleNext(2)"
          >下一步</el-button
        >
      </div>
    </template>
    <template v-if="form.active === 2">
      <StepsStatus
        :key="index"
        :data="status"
        :disabled="true"
        @reload="handleReload"
        v-for="(status, index) in form.statusItems"
      />
      <!-- <div class="logs-content">
        <el-collapse>
          <el-collapse-item title="构建日志" name="1">
            <div>
              Consistent with real life: in line with the process and logic of
              real life, and comply with languages and habits that the users are
              used to;
            </div>
          </el-collapse-item>
        </el-collapse>
      </div> -->
    </template>
  </div>
</template>

<script setup name="PublishSteps">
import {
  reactive,
  computed,
  defineProps,
  defineEmits,
  defineExpose,
} from "vue";
import StepsComp from "./components/steps-comp.vue";
import StepsStatus from "./components/steps-status.vue";
import InstallStatus from "./components/install-status.vue";

let timer = null;
const props = defineProps({
  // 0:分发,1:本地
  buildType: {
    type: Number,
    default: () => {
      return 0;
    },
  },
  // 包应用信息
  formData: {
    type: Object,
    default: () => {
      return {};
    },
  },
});

const emits = defineEmits(["update"]);

const form = reactive({
  active: 0,
  finish: "process",
  status: "process",
  installHap: false,
  statusItems: [],
});

const disabled = computed(() => {
  if (form.active === 0) {
    return !form.statusItems.find((items) => items.finish) ? true : false;
  } else if (form.active === 1) {
    return form.statusItems.find((items) => !items.finish) ? true : false;
  }
  return false;
});

const clearTimer = () => {
  if (timer) {
    clearInterval(timer);
    timer = null;
  }
};

// 下一步
const handleNext = (active) => {
  form.active = active;
  const params = Object.assign({}, props.formData);
  if (active === 1) {
    //调用登录检查
    window.CoreApi.checkAccountInfo(params);
    // 注册登录检查完成回调
  } else if (active === 2) {
    // 开始构建
    window.CoreApi.startBuild(params);
  }
};

// 重载更新
const handleReload = (data) => {
  console.log(data, "handleReload");
};

// 初始化数据轮询
const initPublishSteps = (active) => {
  form.active = active;
  clearTimer();
  timer = setInterval(() => {
    if (form.active === 0) {
      window.CoreApi.getEnvInfo().then((data) => {
        form.installHap = true;
        form.statusItems = data.steps || [];
      });
    } else if (form.active === 1) {
      window.CoreApi.getAccountInfo().then((data) => {
        form.statusItems = data.steps || [];
        form.installHap = data.installHap || true;
      });
    } else if (form.active === 2) {
      window.CoreApi.getBuildInfo(props.buildType).then((data) => {
        form.installHap = true;
        form.statusItems = data.steps || [];
      });
    } else {
      console.error(`未识别类型`);
    }

    emits("update", { ...form });
  }, 500);
};

defineExpose({ initPublishSteps });
</script>
<style lang="scss" scoped>
.publish-steps {
  flex: 1;
  .build-types,
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

  .build-types {
    margin: 20px 4% 0px 4%;
    justify-content: flex-end;
  }
}
</style>
