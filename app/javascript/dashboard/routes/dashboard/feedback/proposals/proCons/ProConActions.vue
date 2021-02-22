<template>
  <div class="flex-container actions--container">
    <woot-button
      class="clear more--button"
      icon="ion-android-more-vertical"
      data-test-id="pro-con-actions-btn"
      @click="toggleActions"
    />
    <div
      v-if="showActions"
      v-on-clickaway="hideActions"
      class="dropdown-pane"
      :class="{ 'dropdown-pane--open': showActions }"
    >
      <div>
        <button
          class="button small clear row alert small-6 action--button"
          data-test-id="pro-con-actions-delete-btn"
          @click="removeProCon"
        >
          <span>delete {{ isPro ? 'proponent' : 'adversary' }}</span>
        </button>
      </div>
    </div>
  </div>
</template>
<script>
import { mapActions } from 'vuex';
import { mixin as clickaway } from 'vue-clickaway';

export default {
  mixins: [clickaway],
  props: {
    id: {
      type: Number,
      required: true,
    },
    isPro: {
      type: Boolean,
      required: true,
    },
  },
  data() {
    return {
      showActions: false,
    };
  },
  methods: {
    ...mapActions('feedback', ['deleteProCon']),
    removeProCon() {
      this.deleteProCon(this.id);
      this.showActions = false;
    },
    toggleActions() {
      this.showActions = !this.showActions;
    },
    hideActions() {
      this.showActions = false;
    },
  },
};
</script>

<style scoped lang="scss">
@import '~dashboard/assets/scss/mixins';
@import '~dashboard/assets/scss/_more-actions';
</style>
