<template>
  <div>
    <h3 class="title is-5">
      {{ title }}
    </h3>
    <ul>
      <Item
        v-for="item of items"
        :id="item.id"
        :key="item.id"
        :body="item.body"
        :status="item.status"
        :title="item.title"
        :feedback-id="item.feedback_id"
      />
    </ul>
  </div>
</template>

<script>
import Item from './Item';

export default {
  name: 'Group',
  components: {
    Item,
  },
  props: {
    items: {
      type: Object,
      default: () => ({}),
    },
    title: {
      type: String,
      default: '',
    },
  },
};
</script>

<style scoped lang="scss">
@import '~widget/assets/feedback/main.scss';
</style>
