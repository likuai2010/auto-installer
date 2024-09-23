<template>
  <div class="packet-phone">
    <el-tooltip effect="light" content="打赏" placement="top">
      <div class="items-content packet">
        <img src="../../assets/images/packet.png" @click="visible = true" />
      </div>
    </el-tooltip>
    <el-tooltip effect="light" content="联系我们" placement="top">
      <div class="items-content phone">
        <img src="../../assets/images/phone.png" @click="visible = true" />
      </div>
    </el-tooltip>
    <el-dialog
      top="25%"
      width="40%"
      v-model="visible"
      :close-on-click-modal="false"
    >
    </el-dialog>
  </div>
</template>

<script setup name="PacketPhone">
import { ref } from "vue";

const visible = ref(false);
</script>
<style lang="scss" scoped>
.packet-phone {
  right: 8%;
  bottom: 10%;
  display: flex;
  position: fixed;
  align-items: center;
  justify-content: center;
  .items-content {
    display: flex;
    align-items: center;
    img {
      width: 32px;
      height: 32px;
      cursor: pointer;
      margin: 0px 6px;
    }
  }
}
</style>
