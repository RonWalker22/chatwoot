<template>
  <div>
    <div>
      <div class="tabs is-centered is-boxed">
        <ul>
          <li
            v-for="(option, index) of tabOptions"
            :key="index"
            :class="{ 'is-active': option === activeTab }"
            @click="updateActiveTab(option)"
          >
            <a>{{ option }}</a>
          </li>
        </ul>
      </div>
      <div v-show="activeTab === 'Roadmap'">
        <Roadmap />
      </div>
      <div v-show="activeTab === 'Feedback'">
        <Feedback />
      </div>
      <div v-show="activeTab === 'Changelog'">
        <Changelog />
      </div>
    </div>
    <footer>
      <i
        class="icon ion-android-chat"
        :style="{ color: widgetColor }"
        title="Chat"
        @click="$emit('decide')"
      />
    </footer>
  </div>
</template>

<script>
import Roadmap from './Roadmap.vue';
import Feedback from './Feedback.vue';
import Changelog from './Changelog.vue';
import { mapGetters } from 'vuex';

export default {
  name: 'FeedbackHome',
  components: {
    Roadmap,
    Feedback,
    Changelog,
  },
  data() {
    return {
      tabOptions: ['Feedback', 'Roadmap', 'Changelog'],
      activeTab: 'Feedback',
    };
  },
  computed: {
    ...mapGetters({
      widgetColor: 'appConfig/getWidgetColor',
    }),
  },
  methods: {
    updateActiveTab(option) {
      this.activeTab = option;
    },
  },
};
</script>

<style scoped lang="scss">
@import 'assets/main.scss';
@import '~widget/assets/scss/variables.scss';

.icon {
  cursor: pointer;
  font-size: $font-size-mega;
  margin-right: $space-small;
}

footer {
  position: fixed;
  bottom: 20px;
  left: 25px;
}
</style>
