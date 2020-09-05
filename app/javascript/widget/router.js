import Vue from 'vue';
import Router from 'vue-router';
import RouterTwo from './views/Router.vue';
import FeedbackHome from './views/FeedbackHome.vue';
import Feedbacks from './components/feedback/Feedbacks.vue';
import Feedback from './components/feedback/Feedback.vue';

Vue.use(Router);

export default new Router({
  routes: [
    {
      path: '/',
      redirect: '/home/feedbacks',
    },
    {
      path: '/home',
      name: 'FeedbackHome',
      component: FeedbackHome,
      children: [
        {
          path: 'feedbacks',
          name: 'Feedbacks',
          component: Feedbacks,
        },
        {
          path: 'feedback/:id',
          name: 'Feedback',
          component: Feedback,
        },
      ],
    },
    {
      path: '/chat',
      name: 'Chat',
      component: RouterTwo,
    },
  ],
});
