<template>
  <div>
    <div class="columns is-centered is-vcentered is-mobile header-div">
      <div class="column is-narrow">
        <h1 class="title is-5 has-text-centered request-title">
          Feature Requests
        </h1>
      </div>
      <div class="column is-narrow">
        <NewFeedback />
      </div>
    </div>
    <div v-for="feedback in feedbacks" :key="feedback.id" class="feedback-box">
      <router-link :to="{ name: 'Feedback', params: { id: feedback.id } }">
        <div class="box">
          <h2 class="title is-6 has-text-centered request-title">
            {{ feedback.title }}
          </h2>
        </div>
      </router-link>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex';
import NewFeedback from './NewFeedback';

export default {
  name: 'Feedbacks',
  components: {
    NewFeedback,
  },
  computed: {
    ...mapGetters({
      feedbacks: 'feedback/getFeedbacks',
    }),
  },
};
</script>

<style scoped lang="scss">
@import '~widget/assets/feedback/main.scss';

.columns {
  &.header-div {
    margin-left: 1em;
    margin-right: 1em;
    border-bottom: 2px $ik4-color solid;
    margin-bottom: 1em;
  }
}

.feedback-box {
  margin-bottom: 1em;
}
</style>
