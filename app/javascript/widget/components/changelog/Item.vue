<template>
  <li>
    <div>
      <div>{{ date }}</div>
      <div>{{ title }}</div>
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
    date: {
      type: String,
      default: '',
    },
  },
};
</script>

<style scoped lang="scss">
@import '~widget/assets/feedback/main.scss';
</style>
