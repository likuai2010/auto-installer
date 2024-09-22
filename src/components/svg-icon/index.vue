<template>
  <svg class="svg-icon" aria-hidden="true" :color="color" :font-size="fontSize">
    <use :xlink:href="`#${icon}`"></use>
  </svg>
</template>

<script setup name="SvgIcon">
defineProps({
  icon: {
    type: String,
    required: true,
  },
  fontSize: {
    type: String,
    default: '',
  },
  color: {
    type: String,
    default: '',
  },
})
</script>

<style lang="scss" scoped>
.svg-icon {
  width: 1em;
  height: 1em;
  vertical-align: -0.15em;
  fill: currentColor;
  overflow: hidden;
  cursor: pointer;
}
</style>
