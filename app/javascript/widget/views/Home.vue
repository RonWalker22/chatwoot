<template>
  <div v-if="homeChoice === undefined" class="home-picker">
    <HomeSelection @decide="choose($event)" />
  </div>
  <div v-else-if="homeChoice === 'chat'" class="home">
    <div class="header-wrap">
      <ChatHeaderExpanded
        v-if="true"
        :intro-heading="introHeading"
        :intro-body="introBody"
        :avatar-url="channelConfig.avatarUrl"
        @decide="choose('feedback')"
      />
      <ChatHeader
        v-else
        :title="channelConfig.websiteName"
        :avatar-url="channelConfig.avatarUrl"
        @decide="choose('feedback')"
      />
    </div>
    <AvailableAgents v-if="showAvailableAgents" :agents="availableAgents" />
    <ConversationWrap :grouped-messages="groupedMessages" />
    <div class="footer-wrap">
      <div v-if="showInputTextArea" class="input-wrap">
        <ChatFooter />
      </div>
      <branding></branding>
    </div>
  </div>
  <div v-else class="feedback-home">
    <FeedbackHome @decide="choose('chat')" />
  </div>
</template>

<script>
import { mapGetters } from 'vuex';

import Branding from 'widget/components/Branding.vue';
import ChatFooter from 'widget/components/ChatFooter.vue';
import ChatHeaderExpanded from 'widget/components/ChatHeaderExpanded.vue';
import ChatHeader from 'widget/components/ChatHeader.vue';
import ConversationWrap from 'widget/components/ConversationWrap.vue';
import AvailableAgents from 'widget/components/AvailableAgents.vue';
import configMixin from '../mixins/configMixin';
import HomeSelection from 'widget/components/feedback/HomeSelection.vue';
import FeedbackHome from 'widget/components/feedback/FeedbackHome.vue';

export default {
  name: 'Home',
  components: {
    ChatFooter,
    ChatHeaderExpanded,
    ConversationWrap,
    ChatHeader,
    Branding,
    AvailableAgents,
    HomeSelection,
    FeedbackHome,
  },
  mixins: [configMixin],
  data() {
    return {
      homeChoice: undefined,
    };
  },
  computed: {
    ...mapGetters({
      groupedMessages: 'conversation/getGroupedConversation',
      conversationSize: 'conversation/getConversationSize',
      availableAgents: 'agent/availableAgents',
      hasFetched: 'agent/uiFlags/hasFetched',
      conversationAttributes: 'conversationAttributes/getConversationParams',
    }),
    isOpen() {
      return this.conversationAttributes.status === 'open';
    },
    showInputTextArea() {
      if (this.hideInputForBotConversations) {
        if (this.isOpen) {
          return true;
        }
        return false;
      }
      return true;
    },
    isHeaderExpanded() {
      return this.conversationSize === 0;
    },
    showAvailableAgents() {
      return this.availableAgents.length > 0 && this.conversationSize < 1;
    },
    introHeading() {
      return this.channelConfig.welcomeTitle;
    },
    introBody() {
      return this.channelConfig.welcomeTagline;
    },
    hideWelcomeHeader() {
      return !(this.introHeading || this.introBody);
    },
  },
  methods: {
    choose(choice) {
      this.homeChoice = choice;
    },
  },
};
</script>

<style scoped lang="scss">
@import '~widget/assets/scss/woot.scss';

.home {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  flex-wrap: nowrap;
  background: $color-background;

  .header-wrap {
    flex-shrink: 0;
    border-radius: $space-normal $space-normal $space-small $space-small;
    background: white;
    z-index: 99;
    @include shadow-large;

    @media only screen and (min-device-width: 320px) and (max-device-width: 667px) {
      border-radius: 0;
    }
  }

  .footer-wrap {
    flex-shrink: 0;
    width: 100%;
    display: flex;
    flex-direction: column;
    position: relative;

    &:before {
      content: '';
      position: absolute;
      top: -$space-normal;
      left: 0;
      width: 100%;
      height: $space-normal;
      opacity: 0.1;
      background: linear-gradient(
        to top,
        $color-background,
        rgba($color-background, 0)
      );
    }
  }

  .input-wrap {
    padding: 0 $space-normal;
  }
}
</style>
