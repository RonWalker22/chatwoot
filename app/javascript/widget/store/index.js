import Vue from 'vue';
import Vuex from 'vuex';
import agent from 'widget/store/modules/agent';
import appConfig from 'widget/store/modules/appConfig';
import contacts from 'widget/store/modules/contacts';
import conversation from 'widget/store/modules/conversation';
import conversationAttributes from 'widget/store/modules/conversationAttributes';
import conversationLabels from 'widget/store/modules/conversationLabels';
import events from 'widget/store/modules/events';
import globalConfig from 'shared/store/globalConfig';
import message from 'widget/store/modules/message';
import feedback from 'widget/store/modules/feedback';
import roadmap from 'widget/store/modules/roadmap';

Vue.use(Vuex);

export default new Vuex.Store({
  modules: {
    agent,
    appConfig,
    contacts,
    conversation,
    conversationAttributes,
    conversationLabels,
    events,
    globalConfig,
    message,
    feedback,
    roadmap,
  },
});
