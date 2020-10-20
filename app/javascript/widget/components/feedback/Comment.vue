<template>
  <article class="media">
    <div class="media-content">
      <div class="content">
        <p>
          <strong>{{ name }}</strong> <small>{{ date }}</small>
        </p>
        <p>
          {{ body }}
        </p>
      </div>
      <nav class="level is-mobile">
        <div class="level-left">
          <a class="level-item">
            <span class="icon "><i class="fas fa-reply"></i></span>
          </a>
          <a class="level-item">
            <span class="icon "><i class="fas fa-retweet"></i></span>
          </a>
          <a class="level-item">
            <span class="icon "><i class="fas fa-heart"></i></span>
          </a>
        </div>
      </nav>
    </div>
  </article>
</template>

<script>
export default {
  name: 'Comment',
  props: {
    name: {
      type: String,
      default: '',
    },
    date: {
      type: String,
      default: '10m',
    },
    body: {
      type: String,
      default: '',
    },
  },
};
</script>

<style lang="scss" scoped>
@import '~widget/assets/feedback/main.scss';
</style>
