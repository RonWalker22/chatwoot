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
        <new-pro-con :proposal-id="proposal.id" />
        <div v-if="isAdmin">
          <button
            v-if="!proposal.primary"
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
        </div>
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
import NewProCon from './proposals/proCons/NewProCon';

export default {
  components: {
    NewProCon,
  },
  mixins: [clickaway],
  props: {
    id: {
      type: [Number, String],
      required: true,
    },
    proposal: {
      type: Object,
      default: () => ({}),
    },
    isSolution: {
      type: Boolean,
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
      currentRole: 'getCurrentRole',
    }),
    isAdmin() {
      return this.currentRole === 'administrator';
    },
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
@import '~dashboard/assets/scss/_more-actions';
</style>
