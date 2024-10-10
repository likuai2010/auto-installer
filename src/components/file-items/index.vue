<template>
  <div
    class="file-items"
    @click.stop="selectedFile"
    @mouseenter.stop="hover = true"
    @mouseleave.stop="hover = false"
  >
    <img
      :src="data.hapInfo.icon"
      :class="['logo', active === data.packageName ? 'active' : '']"
    />
    <span v-if="hover" class="delete">
      <el-icon size="16" color="#000000" @click.stop="deleteFile"
        ><CircleCloseFilled
      /></el-icon>
    </span>
  </div>
</template>

<script setup name="FileItems">
import { ref, reactive, defineProps } from "vue";
import { ElNotification } from "element-plus";
import { CircleCheckFilled, CircleCloseFilled } from "@element-plus/icons-vue";

const hover = ref(false);
const props = defineProps({
  data: {
    type: Object,
    default: () => {
      return {};
    },
  },
  active: {
    type: String,
    default: null,
  },
});

const emits = defineEmits(["delete", "selected"]);

const deleteFile = () => {
  emits("delete", props.data);
};

const selectedFile = () => {
  emits("selected", props.data);
};
</script>

<style lang="scss" scoped>
.file-items {
  position: relative;
  .logo {
    margin: 8px;
    width: 96px;
    height: 96px;
    cursor: pointer;
    border-radius: 5px;
  }

  .active {
    border: 1px solid #05d4f8;
  }

  .delete {
    display: block;
    position: absolute;
    top: 0px;
    right: 0px;
    cursor: pointer;
    color: #000000;
  }
}
</style>
