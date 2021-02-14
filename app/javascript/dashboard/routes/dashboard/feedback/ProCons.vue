<template>
  <div class="row align-center">
    <div class="column pro-cons small-10">
      <div>
        <pro-con v-for="pc in proCons" :key="pc.id" :pro-con="pc"></pro-con>
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
