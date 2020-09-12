<template>
  <div>
    <ul>
      <Item
        v-for="item of items"
        :id="item.id"
        :key="item.id"
        :body="item.body"
        :status="item.status"
        :title="item.title"
        :feedback-id="item.feedback_id"
        :date="item.due_by"
        class="item"
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

.item {
  margin-top: 1em;
}
</style>
