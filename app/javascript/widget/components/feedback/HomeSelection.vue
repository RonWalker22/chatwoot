<template>
  <section class="hero is-fullheight">
    <div class="hero-body">
      <div class="container has-text-centered">
        <button
          class="button is-black feedback is-outlined is-large is-rounded"
          @click="$emit('decide', 'feedback')"
        >
          Feedback
        </button>
        <button
          class="button is-black is-outlined is-large is-rounded"
          @click="$emit('decide', 'chat')"
        >
          Chat
        </button>
      </div>
    </div>
  </section>
</template>

<script>
export default {
  name: 'HomeSelection',
};
</script>

<style scoped lang="scss">
@import 'assets/main.scss';

.hero {
  background-color: $primary-color;
}

.feedback {
  margin-right: $gap;
}
</style>
