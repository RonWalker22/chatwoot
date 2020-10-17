<template>
  <div>
    <h6 class="text-center">
      Clarification Board
    </h6>
    <NewComment />
    <Comment
      v-for="(post, index) in posts"
      :key="post.id"
      :post="post"
      :index="index"
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
    posts: {
      type: Array,
      required: true,
    },
  },
};
</script>
