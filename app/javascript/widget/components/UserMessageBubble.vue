<template>
  <div
    class="chat-bubble user"
    :style="{ background: widgetColor }"
    v-html="formatMessage(message)"
  />
</template>

<script>
import messageFormatterMixin from 'shared/mixins/messageFormatterMixin';

export default {
  name: 'UserMessageBubble',
  mixins: [messageFormatterMixin],
  props: {
    message: {
      type: String,
      default: '',
    },
    status: {
      type: String,
      default: '',
    },
    widgetColor: {
      type: String,
      default: '',
    },
  },
};
</script>

<style lang="scss">
@import '~widget/assets/scss/variables.scss';
@import '~widget/assets/scss/mixins.scss';

.chat-bubble {
  @include light-shadow;
  background: $color-white;
  border: solid 2px black;
  border-radius: $space-two;
  color: $color-body;
  display: inline-block;
  font-size: $font-size-default;
  line-height: 1.5;
  padding: $space-slab $space-normal $space-slab $space-normal;
  text-align: left;
  word-break: break-word;

  > a {
    color: $color-primary;
    word-break: break-all;
  }

  &.user {
    border-bottom-right-radius: $space-smaller;
  }
}
</style>
