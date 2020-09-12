<template>
  <div>
    <div class="columns">
      <div class="column is-full">
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
      </div>
      <div class="column is-full body-column">
        <div v-show="activeTab === 'Roadmap'">
          <Roadmap />
        </div>
        <div v-show="activeTab === 'Feedback'">
          <router-view />
        </div>
        <div v-show="activeTab === 'Changelog'">
          <Changelog />
        </div>
      </div>
      <div class="column is-full feedback-footer">
        <router-link :to="{ name: 'Chat' }">
          <i
            class="icon ion-android-chat"
            :style="{ color: widgetColor }"
            title="Chat"
          />
        </router-link>
      </div>
    </div>
  </div>
</template>

<script>
import Roadmap from '../components/roadmap/Roadmap.vue';
import Changelog from '../components/changelog/Changelog.vue';
import { mapGetters } from 'vuex';

export default {
  name: 'FeedbackHome',
  components: {
    Roadmap,
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
@import '~widget/assets/feedback/main.scss';
@import '~widget/assets/scss/variables.scss';

.icon {
  cursor: pointer;
  font-size: $font-size-mega;
  margin-right: $space-small;
}

.feedback-footer {
  max-height: 10vh;
  margin-left: 1em;
}

.tabs {
  font-size: 1.1em;
}

.body-column {
  max-width: 100%;
  height: 75vh;
  overflow-y: scroll;
  overflow-x: auto;
}

.columns {
  margin: 0;
}
</style>
