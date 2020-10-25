<template>
  <div :class="{ comments: !mainBoard }">
    <h6 v-if="mainBoard" class="text-center">
      Public Board
    </h6>
    <NewComment v-if="mainBoard" :thread-id="threadId" />
    <Comment
      v-for="(post, index) in posts"
      :key="post.id"
      :post="post"
      :index="index"
    />
    <NewComment v-if="!mainBoard" :thread-id="threadId" />
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
  background-color: #fbfbfb;
}
</style>
