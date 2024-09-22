<template>
  <div class="page-home">
    <el-form :model="form" label-width="auto" style="min-width: 1000px">
      <el-form-item label="GitHub地址：">
        <el-input ref="$el1" v-model="form.gitUrls" />
      </el-form-item>
      <el-form-item label="应用名称：">
        <el-input ref="$el2" v-model="form.appName" />
      </el-form-item>
      <el-form-item label="应用包名：">
        <el-input ref="$el3" v-model="form.packageName" />
      </el-form-item>

      <div class="submit-btns-content">
        <el-button ref="$el4" type="primary">开始构建</el-button>
      </div>
    </el-form>
    <el-divider />
    <el-steps :active="active" simple style="min-width: 1000px">
      <el-step ref="$el5" title="环境检查" :icon="Edit" />
      <el-step ref="$el6" title="账号登录" :icon="UploadFilled" />
      <el-step ref="$el7" title="构建状态" :icon="Picture" />
    </el-steps>
    <template v-if="active === 3">
      <div class="construction-progress-content">
        <div class="progress-title">构建进度：</div>
        <div class="progress-content">
          <el-progress
            ref="$el8"
            status="success"
            :stroke-width="18"
            :text-inside="true"
            :percentage="percentage"
          >
            <span>{{ `${percentage}%` }}</span>
          </el-progress>
        </div>
      </div>
    </template>
    <el-collapse ref="$el9" v-model="activeNames">
      <el-collapse-item title="构建日志" name="1">
        <div>
          Consistent with real life: in line with the process and logic of real
          life, and comply with languages and habits that the users are used to;
        </div>
      </el-collapse-item>
    </el-collapse>
    <el-divider />
    <div class="audit-status-content">
      <el-result
        ref="$el10"
        title="审核状态"
        :icon="status.icon"
        :sub-title="status.subTitle"
      >
        <template #extra>
          <div class="status-content">
            <div class="status-content-title">下载地址：</div>
            <el-input v-model="status.dowloadUrl">
              <template #append>
                <el-tooltip effect="light" placement="top" content="复制">
                  <el-button ref="$el11" :icon="CopyDocument" />
                </el-tooltip>
              </template>
            </el-input>
          </div>
        </template>
      </el-result>
    </div>

    <el-tour v-model="open">
      <el-tour-step :target="$el1?.$el" title="输入GitHub地址"> </el-tour-step>
      <el-tour-step :target="$el2?.$el" title="输入应用名称"> </el-tour-step>
      <el-tour-step :target="$el3?.$el" title="输入应用包名"> </el-tour-step>
      <el-tour-step :target="$el4?.$el" title="确认开始构建"> </el-tour-step>
      <el-tour-step :target="$el5?.$el" title="检查本地docker环境">
      </el-tour-step>
      <el-tour-step :target="$el6?.$el" title="开启构建"> </el-tour-step>
      <el-tour-step :target="$el7?.$el" title="构建进度"> </el-tour-step>
      <el-tour-step :target="$el8?.$el" title="可查看构建日志"> </el-tour-step>
      <el-tour-step :target="$el9?.$el" title="等待审核结果"> </el-tour-step>
      <el-tour-step :target="$el10?.$el" title="复制下载连接"></el-tour-step>
      <el-tour-step :target="$el11?.$el" title="复制下载连接"></el-tour-step>
    </el-tour>
  </div>
</template>

<script setup name="HomePage">
import { ref, reactive } from "vue";
import { CopyDocument } from "@element-plus/icons-vue";

const $el1 = ref(null);
const $el2 = ref(null);
const $el3 = ref(null);
const $el4 = ref(null);
const $el5 = ref(null);
const $el6 = ref(null);
const $el7 = ref(null);
const $el8 = ref(null);
const $el9 = ref(null);
const $el10 = ref(null);
const $el11 = ref(null);

const open = ref(true);
const active = ref(1);
const percentage = ref(50);
const activeNames = ref(null);
const form = reactive({ appName: "", gitUrls: "", packageName: "" });
const status = reactive({
  icon: "success",
  subTitle: "正在进行机器审核中",
  dowloadUrl: "www.baidu.com",
});
</script>

<style lang="scss" scoped>
.page-home {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  flex-direction: column;
  justify-content: flex-start;
  .submit-btns-content {
    display: flex;
    justify-content: flex-end;
  }

  .construction-progress-content {
    display: flex;
    min-width: 1200px;
    padding: 30px 0px;
    align-items: center;
    justify-content: flex-start;
    .progress-title {
      width: 64px;
      font-size: 12px;
    }
    .progress-content {
      width: calc(100% - 64px);
    }
  }

  :deep(.el-collapse) {
    min-width: 1200px;
  }

  .audit-status-content {
    min-width: 1200px;
    :deep(.el-result__extra) {
      width: 100%;
      .status-content {
        width: 100%;
        display: flex;
        align-items: center;
        justify-content: flex-start;
        .status-content-title {
        }
      }

      :deep(.el-input) {
        width: calc(100% - 120px);
      }

      :deep(.el-button) {
        width: 100px;
        margin-left: 20px;
      }
    }
  }
}
</style>
