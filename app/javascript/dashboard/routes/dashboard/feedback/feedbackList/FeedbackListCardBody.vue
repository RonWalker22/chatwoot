<template>
  <div
    class="row feedback-row align-top"
    :class="{
      'card-active': selectedFeedbackId == feedback.id && !bulkEditActive,
    }"
    data-test-id="feedback-list-card"
  >
    <div class="column shrink" @click.shift="shiftClickCheckbox()">
      <label v-show="bulkEditActive" class="checkbox">
        <span class="checkbox__input">
          <input
            id="checkbox1"
            :checked="bulkEditCheckStatus[index]"
            type="checkbox"
            @click.exact="clickCheckbox()"
          />
          <span class="checkbox__control">
            <i class="ion-checkmark-round" aria-hidden="true"> </i>
          </span>
        </span>
      </label>
      <div
        v-show="!bulkEditActive"
        class="icon-container"
        @click="firstClickCheckbox()"
      >
        <transition name="fade">
          <i
            v-if="feedback.kind === 'bug'"
            class="ion-bug"
            :class="{
              'icon-bug-reject': feedback.status === 'reject',
              'icon-bug-accept': feedback.status === 'accept',
              'icon-bug-upcoming': feedback.status === 'upcoming',
              'icon-bug-preview': feedback.status === 'preview',
            }"
            aria-hidden="true"
          >
          </i>
          <request-hand-icon
            v-else
            class="request-hand"
            :icon-color="findIconColor"
          />
        </transition>
      </div>
    </div>
    <div
      class="column"
      @click.exact="cardClick(feedback.id)"
      @click.shift="cardClickShift()"
    >
      <p>{{ feedback.title }}</p>
      <p>
        <span class="feedback-kind">{{ feedback.kind }}</span>
      </p>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex';
import router from '../../../../routes';
import { frontendURL, feedbackUrl } from '../../../../helper/URLHelper';
import RequestHandIcon from './RequestHandIcon';

export default {
  components: {
    RequestHandIcon,
  },
  props: {
    feedback: {
      type: Object,
      require: true,
      default: () => {},
    },
    index: {
      type: Number,
      default: 0,
    },
  },
  computed: {
    ...mapGetters({
      bulkEditActive: 'feedback/getBulkEditActive',
      selectedFeedbackId: 'feedback/getSelectedFeedbackId',
      bulkSelectIndex: 'feedback/getBulkSelectIndex',
      bulkEditCheckStatus: 'feedback/getBulkEditCheckStatus',
      accountId: 'getCurrentAccountId',
    }),
    findIconColor() {
      switch (this.feedback.status) {
        case 'accept':
          return '#139713';
        case 'reject':
          return '#b22222';
        case 'preview':
          return '#8b69d1';
        case 'upcoming':
          return '#7e7e7e';
        default:
          return '#277dce';
      }
    },
  },
  mounted() {
    ['keyup', 'keydown'].forEach(event => {
      window.addEventListener(event, e => {
        document.onselectstart = () => {
          return !(e.key === 'Shift' && e.shiftKey);
        };
      });
    });
  },
  methods: {
    ...mapActions('feedback', [
      'setBulkSelectIndex',
      'setBulkEditCheckStatus',
      'resetSelectedFeedbackId',
    ]),
    pathReset() {
      this.resetSelectedFeedbackId();
      const path = feedbackUrl({
        accountId: this.accountId,
      });
      router.push({ path: frontendURL(path) });
    },
    shiftClickCheckbox() {
      if (!this.bulkEditCheckStatus[this.index]) {
        this.setBulkEditCheckStatus([
          {
            index: this.index,
            payload: true,
          },
        ]);
        this.setBulkSelectIndex({
          previous: this.index,
          current: this.bulkSelectIndex.current,
        });
        this.bulkSelected();
      } else {
        this.setBulkEditCheckStatus([
          {
            index: this.index,
            payload: false,
          },
        ]);
      }
    },
    firstClickCheckbox() {
      this.pathReset();
      this.clickCheckbox();
    },
    clickCheckbox() {
      if (!this.bulkEditCheckStatus[this.index]) {
        this.setBulkEditCheckStatus([
          {
            index: this.index,
            payload: true,
          },
        ]);
        this.setBulkSelectIndex({
          previous: this.bulkSelectIndex.previous,
          current: this.index,
        });
      } else {
        this.setBulkEditCheckStatus([
          {
            index: this.index,
            payload: false,
          },
        ]);
      }
    },
    cardClick(feedbackId) {
      if (!this.bulkEditActive) {
        this.$store.dispatch('feedback/setSelectedFeedbackId', feedbackId);
        this.updateFeedback(feedbackId);
        const path = feedbackUrl({
          accountId: this.accountId,
          id: feedbackId,
        });
        router.push({ path: frontendURL(path) });
      } else {
        this.clickCheckbox();
      }
    },
    cardClickShift() {
      if (this.bulkEditActive) {
        this.shiftClickCheckbox();
      }
    },
    updateFeedback(id) {
      this.$store.dispatch('feedback/fetchFeedbackItem', id);
    },
    bulkSelected() {
      const sortedIndexes = Object.values(this.bulkSelectIndex).sort();
      let i = sortedIndexes[0];
      let checkStatus = [];
      do {
        checkStatus.push({
          index: i,
          payload: true,
        });
        i += 1;
      } while (i < sortedIndexes[1]);
      this.setBulkEditCheckStatus(checkStatus);
      return this.bulkEditCheckStatus[this.index];
    },
  },
};
</script>

<style scoped lang="scss">
@import '~dashboard/assets/scss/variables';
@import '~dashboard/assets/scss/mixins';

.feedback-row {
  background: transparent;
  &:hover {
    background: #cce8ff;
    cursor: pointer;
  }
}

h3 {
  font-size: 1.5rem;
}

.card-active {
  background: #f4f6fb;
}

.title-row {
  padding: 1.5em;
}

.container-titles {
  font-size: 1.5rem;
  color: black;
  margin-left: 1rem;
}

.no-evaluations {
  p {
    margin-top: 8rem;
    margin-bottom: 8rem;
  }
}

.ion-bug,
.ion-checkmark-round {
  border: none;
  background: transparent;
  position: relative;
}

.ion-bug {
  font-size: 4rem;
  color: #277dce;
}

.icon-bug-reject {
  color: #b22222;
}

.icon-bug-accept {
  color: #139713;
}

.icon-bug-preview {
  color: #8b69d1;
}

.icon-bug-upcoming {
  color: #7e7e7e;
}

.icon-container {
  margin-left: 1rem;
  margin-right: 1rem;
  height: 4.5rem;
  width: 3.5rem;
}

.ion-checkmark-round {
  font-size: 2rem;
  padding-left: 0.6rem;
  color: #277dce;
}

.request-hand {
  height: 4.5rem;
  width: 3.5rem;
  margin-top: 0.5rem;
  position: relative;
}

.checkbox {
  height: 4.5rem;
  width: 3.5rem;
  display: grid;
  grid-template-columns: min-content auto;
  grid-gap: 0.5em;
  font-size: 2rem;
  margin-left: 1rem;
  margin-right: 1rem;
  &:hover {
    cursor: pointer;
  }
}

.checkbox__control {
  display: inline-grid;
  height: 4.5rem;
  width: 3.5rem;
  margin-top: 0.5rem;
  border: #277dce solid 4px;
}

.checkbox__input {
  input {
    opacity: 0;
    width: 1em;
    height: 1em;
  }
  display: grid;
  grid-template-areas: 'checkbox';
  > * {
    grid-area: checkbox;
  }
  &:hover {
    cursor: pointer;
  }
}

.checkbox__control .ion-checkmark-round {
  transform: scale(0);
  transform-origin: bottom left;
}

.checkbox__input input:checked + .checkbox__control .ion-checkmark-round {
  transform: scale(1);
}

.fade-enter-active {
  transition: opacity 3s;
}

.fade-enter, .fade-leave-to /* .fade-leave-active below version 2.1.8 */ {
  opacity: 0;
}

.feedback-kind {
  font-size: $font-size-mini;
  text-align: right;
}
</style>
