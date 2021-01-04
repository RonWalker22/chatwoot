<template>
  <div class="flex-container actions--container">
    <woot-button
      class="clear more--button"
      icon="ion-android-more-vertical"
      data-test-id="more-toolbar-btn"
      @click="toggleActions"
    />
    <div
      v-if="showActions"
      v-on-clickaway="hideActions"
      class="dropdown-pane"
      :class="{ 'dropdown-pane--open': showActions }"
    >
      <div v-if="isSolution">
        <button
          v-if="!isPrimary"
          class="button small clear row small-6 action--button"
          data-test-id="proposal-add-primary"
          @click="addPrimary"
        >
          <span>mark as primary</span>
        </button>
        <button
          v-else
          class="button small clear row small-6 action--button"
          data-test-id="proposal-remove-primary"
          @click="removePrimary"
        >
          <span>remove primary mark</span>
        </button>
        <button
          class="button small clear row alert small-6 action--button"
          data-test-id="delete-proposal"
          @click="removeSolution"
        >
          <span>delete solution</span>
        </button>
      </div>
      <div v-else>
        <button
          class="button small clear row alert small-6 action--button"
          data-test-id="delete-comment"
          @click="removeComment"
        >
          <span>delete comment</span>
        </button>
      </div>
    </div>
  </div>
</template>
<script>
import { mapGetters, mapActions } from 'vuex';
import { mixin as clickaway } from 'vue-clickaway';

export default {
  mixins: [clickaway],
  props: {
    id: {
      type: [String, Number],
      required: true,
    },
    isSolution: {
      type: Boolean,
      require: true,
      default: false,
    },
    isPrimary: {
      type: Boolean,
      require: true,
      default: false,
    },
  },
  data() {
    return {
      showActions: false,
    };
  },
  computed: {
    ...mapGetters({
      currentChat: 'getSelectedChat',
    }),
  },
  methods: {
    ...mapActions('feedback', ['deleteComment']),
    ...mapActions('feedback', ['deleteProposal', 'updateProposal']),
    removeComment() {
      this.deleteComment(this.id);
      this.hideActions();
    },
    removeSolution() {
      this.deleteProposal(this.id);
      this.hideActions();
    },
    toggleActions() {
      this.showActions = !this.showActions;
    },
    hideActions() {
      this.showActions = false;
    },
    removePrimary() {
      this.hideActions();
      this.updateProposal({
        id: this.id,
        payload: {
          proposal: {
            id: this.id,
            primary: false,
          },
        },
      });
    },
    addPrimary() {
      this.hideActions();
      this.updateProposal({
        id: this.id,
        payload: {
          proposal: {
            id: this.id,
            primary: true,
          },
        },
      });
    },
  },
};
</script>
<style scoped lang="scss">
@import '~dashboard/assets/scss/mixins';

.more--button {
  align-items: center;
  display: flex;
  margin-left: var(--space-small);
  padding: var(--space-small);

  &.clear.more--button {
    color: var(--color-body);
  }

  &:hover {
    color: var(--w-800);
  }
}

.actions--container {
  position: relative;
}

.dropdown-pane {
  @include elegant-card;
  @include border-light;
  right: -12px;
  top: 48px;
  width: auto;

  &::before {
    @include arrow(top, var(--color-border-light), 14px);
    top: -14px;
    position: absolute;
    right: 6px;
  }

  &::after {
    @include arrow(top, white, var(--space-slab));
    top: -12px;
    position: absolute;
    right: var(--space-small);
  }
}

.dropdown-pane--open {
  display: block;
  visibility: visible;
}

.action--button {
  display: flex;
  align-items: center;
  width: 100%;
  white-space: nowrap;
  padding: var(--space-small) var(--space-smaller);
  font-size: var(--font-size-small);

  .icon {
    margin-right: var(--space-smaller);
    min-width: var(--space-normal);
  }
}
</style>
