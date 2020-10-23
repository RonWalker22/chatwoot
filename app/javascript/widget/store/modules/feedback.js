/* eslint-disable no-param-reassign */
import Vue from 'vue';
import {
  getFeedbacksAPI,
  createFeedbackAPI,
  createCommentAPI,
  createSupporterAPI,
} from 'widget/api/feedback';

const state = {
  feedbacks: {
    active: {},
    review: {},
    rejected: {},
    campaign: {},
  },
};

export const getters = {
  getFeedbacks: _state => _state.feedbacks.active,
  getFeedback: _state => id => {
    return _state.feedbacks.active[id];
  },
};

export const actions = {
  fetchOldFeedbacks: async ({ commit }, token = {}) => {
    const { data } = await getFeedbacksAPI(token);
    commit('addFeedbacks', data);
  },

  createFeedback: async ({ commit }, payload = {}) => {
    const { data } = await createFeedbackAPI(payload);
    commit('addFeedback', data);
  },

  createComment: async ({ commit }, payload = {}) => {
    const { data } = await createCommentAPI(payload);
    commit('addComment', data);
  },

  createSupporter: async ({ commit }, payload = {}) => {
    const { data } = await createSupporterAPI(payload);
    commit('addSupporter', data);
  },
};

export const mutations = {
  addFeedbacks($state, payload) {
    payload.forEach(feedback => {
      Vue.set($state.feedbacks.active, feedback.id, {
        id: feedback.id,
        title: feedback.title,
        proposals: feedback.proposals,
        posts: feedback.posts,
        contact: feedback.contact,
        supported: feedback.supported,
      });
    });
  },

  addFeedback($state, payload) {
    Vue.set($state.feedbacks.review, payload.id, {
      id: payload.id,
      proposals: payload.proposals,
      posts: payload.posts,
      title: payload.title,
    });
  },

  addSupporter($state, payload) {
    let newFeedback = {};
    let status = payload.feedback_status;
    let feedback = $state.feedbacks[status][payload.feedback_id];

    Object.assign(newFeedback, feedback);
    newFeedback.supported = true;

    Vue.set($state.feedbacks[status], payload.feedback_id, newFeedback);
  },

  addComment($state, payload) {
    let newFeedback = {};
    let status = payload.feedback_status;
    let feedback = $state.feedbacks[status][payload.feedback_id];

    Object.assign(newFeedback, feedback);
    newFeedback.posts.push(payload.post);

    Vue.set($state.feedbacks[status], payload.feedback_id, newFeedback);
  },
};

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations,
};
