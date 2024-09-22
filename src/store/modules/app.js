export default {
  state: {
    menu: null,
    loaded: true,
    loading: false,
    collapse: false,
  },
  mutations: {
    setMenu(state, menu) {
      state.menu = menu;
    },
    setLoaded(state, loaded) {
      state.loading = loaded;
    },
    setloading(state, loading) {
      state.loading = loading;
    },
    setCollapse(state, collapse) {
      state.collapse = collapse;
    },
  },
  actions: {},
  namespaced: true,
};
