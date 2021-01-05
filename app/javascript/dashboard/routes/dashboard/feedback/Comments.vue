<template>
  <div :class="{ comments: !mainBoard, 'public-board': mainBoard }">
    <h6 v-if="mainBoard" class="text-center">
      Public Comments
    </h6>
    <Comment
      v-for="(post, index) in posts"
      :key="post.id"
      :post="post"
      :index="index"
    />
    <NewComment
      :thread-id="threadId"
      :main-board="mainBoard"
      :is-public="mainBoard"
      :is-problem="problem"
    />
  </div>
</template>

<script>
import Comment from './Comment';
import NewComment from './NewComment';

export default {
  components: {
    Comment,
    NewComment,
  },
  props: {
    mainBoard: {
      type: Boolean,
      requried: true,
      default: false,
    },
    threadId: {
      type: Number,
      required: true,
      default: 0,
    },
    feedbackId: {
      type: Number,
      required: true,
      default: 0,
    },
    problem: {
      type: Boolean,
      default: false,
    },
  },
  computed: {
    posts() {
      return this.$store.getters['feedback/getPosts'](
        this.feedbackId,
        this.threadId
      );
    },
  },
};
</script>

<style lang="scss" scoped>
.comments {
  background-color: transparent;
  padding-left: 3em;
}

.public-board {
  margin-top: 5em;
  border-top: 4px solid blueviolet;
  border-left: 4px solid blueviolet;
  padding: 3rem;
  .callout {
    background-color: transparent;
  }
  h6 {
    margin-bottom: 1em;
    color: blueviolet;
  }
}
</style>
