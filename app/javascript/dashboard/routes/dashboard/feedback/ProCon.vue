<template>
  <div
    class="row align-center pro-con-row"
    data-test-id="pro-con-card"
    :class="[proCon.pro ? 'pro' : 'con']"
  >
    <div class="column">
      <h5 data-test-id="pro-con-heading">
        {{ proCon.pro ? 'Pro' : 'Con' }}
      </h5>
      <p data-test-id="pro-con-body">
        {{ proCon.body }}
      </p>
    </div>
    <div class="column shrink">
      <pro-con-actions :id="proCon.id" :is-pro="proCon.pro" />
    </div>
  </div>
</template>

<script>
import ProConActions from './ProConActions';

export default {
  components: {
    ProConActions,
  },
  props: {
    proCon: {
      type: Object,
      required: true,
    },
  },
};
</script>

<style lang="scss" scoped>
@import '~dashboard/assets/scss/variables';

.con,
.pro {
  padding: 3rem;
  box-shadow: -2px 2px 5px gainsboro;
}

.con {
  h5 {
    color: firebrick;
  }
}

.pro {
  h5 {
    color: $color-woot;
  }
}

.pro-con-row {
  margin-top: 3rem;
}
h5 {
  display: inline-block;
  padding: 0.5rem;
  font-size: 1.5rem;
  color: white;
  border-radius: 0;
  padding: 0;
}
</style>
