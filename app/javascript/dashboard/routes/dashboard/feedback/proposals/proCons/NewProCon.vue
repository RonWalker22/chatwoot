<template>
  <div>
    <transition name="modal-fade">
      <div
        v-if="show"
        class="modal-mask"
        transition="modal"
        data-test-id="new-pro-con-cancel-modal-mask"
        @click="cancelModal"
      >
        <div class="modal-container" @click.stop>
          <div class="modal-content">
            <div class="row">
              <h1 data-test-id="new-pro-con-title">
                New Pro/Con
              </h1>
              <i
                class="ion-android-close modal--close"
                data-test-id="new-pro-con-cancel-icon"
                @click="cancelModal"
              ></i>
            </div>
            <form>
              <div class="row">
                <div class="small-12 columns">
                  <div class="form-item">
                    <textarea
                      v-model="proCon.body"
                      tabindex="0"
                      placeholder="Shift + enter for new line."
                      rows="5"
                      data-test-id="new-pro-con-textarea-body"
                      @keydown.enter.exact.prevent="submitProCon"
                    >
                    </textarea>
                  </div>
                </div>
              </div>
              <fieldset class="large-5 cell">
                <input
                  id="pcPro"
                  type="radio"
                  name="pokemon"
                  value="pro"
                  required
                  checked
                  data-test-id="new-pro-con-radio-pro"
                  @click="proCon.pro = true"
                /><label for="pcPro">Pro</label>
                <input
                  id="pcCon"
                  type="radio"
                  name="pokemon"
                  value="con"
                  data-test-id="new-pro-con-radio-con"
                  @click="proCon.pro = false"
                /><label for="pcCon">Con</label>
              </fieldset>
              <div class="modal-footer">
                <div class="medium-12 columns">
                  <div class="button-group">
                    <button
                      class="button"
                      type="submit"
                      data-test-id="new-pro-con-submit-btn"
                      @click.prevent="submitProCon"
                    >
                      Submit
                    </button>
                    <button
                      class="button clear"
                      data-test-id="new-pro-con-cancel-btn"
                      @click.prevent="cancelModal"
                    >
                      Cancel
                    </button>
                  </div>
                </div>
              </div>
            </form>
          </div>
        </div>
      </div>
    </transition>
    <button
      class="button small clear row small-6 action--button"
      data-test-id="proposal-add-pro-con"
      @click="openModal"
    >
      add pro/con
    </button>
  </div>
</template>

<script>
import { mapActions } from 'vuex';

export default {
  props: {
    proposalId: {
      type: Number,
      default: 0,
      required: true,
    },
  },
  data() {
    return {
      show: false,
      proCon: {
        body: '',
        pro: true,
      },
    };
  },
  methods: {
    ...mapActions('feedback', ['createProCon']),
    cancelModal() {
      this.proCon.body = '';
      this.show = false;
    },
    openModal() {
      this.show = true;
    },
    getProConObject() {
      return {
        pro_con: {
          body: this.proCon.body,
          pro: this.proCon.pro,
        },
        proposal_id: this.proposalId,
      };
    },
    submitProCon() {
      if (this.proCon.body.length !== 0) {
        this.createProCon(this.getProConObject());
        this.cancelModal();
      }
    },
  },
};
</script>

<style lang="scss" scoped>
.modal-content {
  padding: 3rem;
}

.form-item {
  margin-bottom: 4rem;
}

.action--button {
  display: flex;
  align-items: center;
  width: 100%;
  white-space: nowrap;
  padding: var(--space-small) var(--space-smaller);
  font-size: var(--font-size-small);
}

#add-pro-con-btn:hover:after {
  content: attr(alt);
  position: absolute;
  top: 0;
  right: 100%;
  color: white;
  background: black;
  padding: 1em;
}
#add-pro-con-btn:disabled:hover {
  opacity: 1;
}
</style>
