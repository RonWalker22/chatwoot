<template>
  <li>
    <div class="box">
      <div>{{ title }}</div>
      <div>{{ body }}</div>
      <div>{{ status }}</div>
      <div>{{ id }}</div>
      <div v-if="feedbackId">
        {{ feedbackId }}
      </div>
    </div>
  </li>
</template>

<script>
export default {
  name: 'Group',
  props: {
    title: {
      type: String,
      default: '',
    },
    id: {
      type: Number,
      default: -1,
    },
    body: {
      type: String,
      default: '',
    },
    status: {
      type: String,
      default: '',
    },
    feedbackId: {
      type: Number,
    },
  },
};
</script>

<style scoped lang="scss">
@import '~widget/assets/feedback/main.scss';
</style>
