/* eslint arrow-body-style: 0 */
import { frontendURL } from '../../../helper/URLHelper';
import Index from './Index';

export default {
  routes: [
    {
      path: frontendURL('accounts/:accountId/feedback'),
      component: Index,
      name: 'feedback_home',
      roles: ['administrator', 'agent'],
    },
    {
      path: frontendURL('accounts/:accountId/feedback/:feedback_id'),
      name: 'feedback_item',
      roles: ['administrator', 'agent'],
      component: Index,
      props: route => {
        return { feedbackId: route.params.feedback_id };
      },
    },
    {
      path: frontendURL('accounts/:accountId/label/:label/feedback'),
      name: 'label_feedback',
      roles: ['administrator', 'agent'],
      component: Index,
      props: route => ({ label: route.params.label }),
    },
    {
      path: frontendURL(
        'accounts/:accountId/label/:label/feedback/:feedback_id'
      ),
      name: 'feedback_through_label',
      roles: ['administrator', 'agent'],
      component: Index,
      props: route => ({
        feedbackId: route.params.feedback_id,
        label: route.params.label,
      }),
    },
  ],
};
