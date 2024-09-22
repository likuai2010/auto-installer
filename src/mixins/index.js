import store from "@/store";
import SvgIcon from "@/components/svg-icon/index.vue";

const mixins = {
  methods: {
    reload() {
      store.state.app.loaded = false;
      setTimeout(() => {
        store.state.app.loaded = true;
      }, 0);
    },
  },
  components: {
    SvgIcon,
  },
  directives: {},
};
export default mixins;
