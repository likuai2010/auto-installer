<template>
  <div class="packet-phone">
    <el-tooltip effect="light" content="打赏" placement="top">
      <div class="items-content packet">
        <img src="../../assets/images/packet.png" @click="visible = true" />
      </div>
    </el-tooltip>
    <!-- <el-tooltip effect="light" content="联系我们" placement="top">
      <div class="items-content phone">
        <img src="../../assets/images/phone.png" @click="visible = true" />
      </div>
    </el-tooltip> -->
    <el-dialog width="360px" v-model="visible" :close-on-click-modal="false">
      <div class="weixin-alipay-items">
        <img class="weixin" src="../../assets/images/weixin.png" />
        <img class="alipay" src="../../assets/images/alipay.png" />
      </div>
      <div>
        打赏支持作者，助力移植更多开源应用。您的每一份支持，都是对开源精神的传承，共同推动技术创新与共享！
      </div>
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
    justify-content: center;
    img {
      width: 32px;
      height: 32px;
      cursor: pointer;
      margin: 0px 6px;
    }
  }

  .weixin-alipay-items {
    display: flex;
    max-width: 320px;
    align-items: center;
    justify-content: space-around;
    .weixin {
      width: 150px;
      height: 150px;
    }
    .alipay {
      height: 150px;
      height: 150px;
    }
  }
}
</style>
