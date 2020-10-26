import * as MutationHelpers from 'shared/helpers/vuex/mutationHelpers';
import * as types from '../mutation-types';
import FeedbackAPI from '../../api/feedbacks';
import ClarificationPostsAPI from '../../api/clarificationPosts';
import FeedbackUsersAPI from '../../api/feedbackUsers';
import ProposalsAPI from '../../api/proposals';
import Vue from 'vue';

export const state = {
  records: [],
  uiFlags: {
    fetchingList: false,
    fetchingItem: false,
    creatingItem: false,
    updatingItem: false,
    deletingItem: false,
  },
  feedbackStatusFilter: 'review',
};

export const getters = {
  getAllFeedback($state) {
    const feedback = $state.records.filter(
      record => record.status === $state.feedbackStatusFilter
    );
    return feedback || {};
  },
  getFeedbackItem: $state => feedbackId => {
    const [feedback] = $state.records.filter(
      record => record.id === Number(feedbackId)
    );
    return feedback || {};
  },
  getPosts: ($state, $getters) => (feedbackId, threadId) => {
    const feedback = $getters.getFeedbackItem(feedbackId);
    return feedback.posts.filter(post => {
      return post.thread === threadId;
    });
  },
  getUIFlags($state) {
    return $state.uiFlags;
  },
};

export const actions = {
  fetchAllFeedback: async ({ commit }) => {
    commit(types.default.SET_FEEDBACK_UI_FLAG, { fetchingList: true });
    try {
      const response = await FeedbackAPI.get();
      commit(types.default.SET_FEEDBACKS, response.data);
      commit(types.default.SET_FEEDBACK_UI_FLAG, { fetchingList: false });
    } catch (error) {
      commit(types.default.SET_FEEDBACK_UI_FLAG, { fetchingList: false });
    }
  },
  fetchFeedbackItem: async ({ commit }, id) => {
    commit(types.default.SET_FEEDBACK_UI_FLAG, { fetchingItem: true });
    try {
      const response = await FeedbackAPI.show(id);
      commit(types.default.EDIT_FEEDBACK, response.data);
      commit(types.default.SET_FEEDBACK_UI_FLAG, { fetchingItem: false });
    } catch (error) {
      commit(types.default.SET_FEEDBACK_UI_FLAG, { fetchingItem: false });
    }
  },
  updateFeedback: async ({ commit }, feedback) => {
    commit(types.default.SET_FEEDBACK_UI_FLAG, { updatingItem: true });
    try {
      const response = await FeedbackAPI.update(feedback.id, feedback.payload);
      commit(types.default.UPDATE_FEEDBACK, response.data);
      commit(types.default.SET_FEEDBACK_UI_FLAG, { updatingItem: false });
    } catch (error) {
      commit(types.default.SET_FEEDBACK_UI_FLAG, { updatingItem: false });
    }
  },
  createFeedback: async ({ commit }, newFeedback) => {
    try {
      const response = await FeedbackAPI.create(newFeedback);
      commit(types.default.ADD_FEEDBACK, response.data);
    } catch (error) {
      throw new Error(error);
    }
  },
  createComment: async ({ commit }, newComment) => {
    try {
      const response = await ClarificationPostsAPI.create(newComment);
      commit(types.default.ADD_COMMENT, response.data);
    } catch (error) {
      throw new Error(error);
    }
  },
  createSolution: async ({ commit }, newSolution) => {
    try {
      const response = await ProposalsAPI.create(newSolution);
      commit(types.default.ADD_SOLUTION, response.data);
    } catch (error) {
      throw new Error(error);
    }
  },
  deleteSolution: async ({ commit }, id) => {
    try {
      const response = await ProposalsAPI.delete(id);
      commit(types.default.DELETE_SOLUTION, response.data);
    } catch (error) {
      throw new Error(error);
    }
  },
  deleteComment: async ({ commit }, id) => {
    try {
      const response = await ClarificationPostsAPI.delete(id);
      commit(types.default.DELETE_COMMENT, response.data);
    } catch (error) {
      throw new Error(error);
    }
  },
  setFeedbackFilter({ commit }, data) {
    commit(types.default.CHANGE_FEEDBACK_STATUS_FILTER, data);
  },
  setFeedbackEvaluation: async ({ commit }, data) => {
    try {
      if (!data.feedbackUser) {
        const createResponse = await FeedbackUsersAPI.create(data);
        data.id = createResponse.data.id;
      }
      const updateResponse = await FeedbackUsersAPI.update(
        data.id,
        data.payload
      );
      commit(types.default.UPDATE_FEEDBACK, updateResponse.data);
    } catch (error) {
      throw new Error(error);
    }
  },
};

export const mutations = {
  [types.default.SET_FEEDBACK_UI_FLAG]($state, uiFlag) {
    $state.uiFlags = { ...$state.uiFlags, ...uiFlag };
  },
  [types.default.SET_FEEDBACKS]: MutationHelpers.set,
  [types.default.SET_FEEDBACK_ITEM]: MutationHelpers.setSingleRecord,
  [types.default.ADD_FEEDBACK]: MutationHelpers.create,
  [types.default.EDIT_FEEDBACK]: MutationHelpers.update,
  [types.default.UPDATE_FEEDBACK]: MutationHelpers.updateAttributes,
  [types.default.DELETE_FEEDBACK]: MutationHelpers.destroy,
  [types.default.ADD_SOLUTION]: MutationHelpers.create,

  [types.default.DELETE_COMMENT](_state, payload) {
    let newFeedback = {};
    const index = state.records.findIndex(
      record => record.id === payload.feedback_id
    );
    let feedback = _state.records[index];

    Object.assign(newFeedback, feedback);
    let newPosts = newFeedback.posts.filter(post => {
      return post.id !== payload.id;
    });
    newFeedback.posts = newPosts;

    Vue.set(_state.records, index, newFeedback);
  },

  [types.default.ADD_COMMENT](_state, payload) {
    let newFeedback = {};
    const index = state.records.findIndex(
      record => record.id === payload.feedback_id
    );
    let feedback = _state.records[index];

    Object.assign(newFeedback, feedback);
    newFeedback.posts.push(payload.post);

    Vue.set(_state.records, index, newFeedback);
  },
  [types.default.ADD_SOLUTION](_state, payload) {
    let newFeedback = {};
    const index = state.records.findIndex(
      record => record.id === payload.feedback_id
    );
    let feedback = _state.records[index];

    Object.assign(newFeedback, feedback);
    newFeedback.proposals.push(payload);

    Vue.set(_state.records, index, newFeedback);
  },
  [types.default.DELETE_SOLUTION](_state, payload) {
    let newFeedback = {};
    const index = state.records.findIndex(
      record => record.id === payload.feedback_id
    );
    let feedback = _state.records[index];

    Object.assign(newFeedback, feedback);
    let newProposal = newFeedback.proposals.filter(proposal => {
      return proposal.id !== payload.id;
    });
    newFeedback.proposals = newProposal;

    Vue.set(_state.records, index, newFeedback);
  },
  [types.default.CHANGE_FEEDBACK_STATUS_FILTER](_state, data) {
    _state.feedbackStatusFilter = data;
  },
};

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations,
};
