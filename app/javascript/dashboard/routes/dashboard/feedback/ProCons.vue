<template>
  <div class="row align-center">
    <div class="column pro-cons small-7">
      <div v-if="show">
        <pro-con v-for="pc in proCons" :key="pc.id" :pro-con="pc"></pro-con>
        <button
          class="hide-btn button clear"
          data-test-id="pro-con-hide-btn"
          @click="show = false"
        >
          hide
        </button>
      </div>
      <div v-else class="text-center">
        <button
          class="button small hollow"
          data-test-id="pro-con-show-btn"
          @click="show = true"
        >
          show pros({{ total.pros }}) cons({{ total.cons }})
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import ProCon from './ProCon';

export default {
  components: {
    ProCon,
  },
  props: {
    proCons: {
      type: Array,
      required: true,
    },
  },
  data() {
    return {
      show: false,
    };
  },
  computed: {
    total() {
      let counter = { pros: 0, cons: 0 };
      this.proCons.forEach(proCon => {
        if (proCon.pro) {
          counter.pros += 1;
        } else {
          counter.cons += 1;
        }
      });
      return counter;
    },
  },
};
</script>

<style lang="scss" scoped>
.hide-btn {
  font-size: 1.3rem;
  color: #3c4858;
  text-decoration: underline;
}
.pro-cons {
  margin-bottom: 5rem;
}
</style>
