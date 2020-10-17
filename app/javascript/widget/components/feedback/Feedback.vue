<template>
  <div class="fb-container">
    <router-link
      class="button is-small back-link is-info is-outlined"
      :to="{ name: 'Feedbacks' }"
    >
      <i class="ion-android-arrow-back icon" aria-hidden="true" />
      <span class="is-sr-only">All Requests</span>
    </router-link>
    <h1 class="title is-5 has-text-centered">
      {{ feedbacks[$route.params.id].title }}
    </h1>
    <SupportFeedback
      :fb-id="feedbacks[$route.params.id].id"
      :supporter="feedbacks[$route.params.id].supported"
    />
    <div v-if="feedbacks[$route.params.id].problems" class="box">
      <h2 class="title is-6">
        Problem
      </h2>
      <p>{{ feedbacks[$route.params.id].problems[0].details }}</p>
    </div>
    <div v-if="feedbacks[$route.params.id].solutions" class="box">
      <h2 class="title is-6">
        Solution
      </h2>
      <p>{{ feedbacks[$route.params.id].solutions[0].details }}</p>
    </div>
    <h2 class="title is-6 has-text-centered">
      Clarification Board
    </h2>
    <NewComment :fb-id="feedbacks[$route.params.id].id" />
    <Comment
      v-for="post in feedbacks[$route.params.id].posts"
      :key="post.id"
      :name="post.author"
      :body="post.body"
      :date="post.datetime"
    >
    </Comment>
  </div>
</template>

<script>
import { mapGetters } from 'vuex';
import NewComment from './NewComment';
import Comment from './Comment';
import SupportFeedback from './SupportFeedback';

export default {
  name: 'Feedback',
  components: {
    NewComment,
    Comment,
    SupportFeedback,
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
.icon {
  font-size: 1.5em;
}

.back-link {
  margin-bottom: 1em;
}

h2 {
  margin-bottom: 1em;
}

.fb-container {
  margin-right: 1em;
  margin-left: 1em;
}

.sponsor-btn {
  margin-bottom: 1em;
}

.submit-container {
  margin-top: 2.5em;
}
</style>
