import * as MutationHelpers from 'shared/helpers/vuex/mutationHelpers';
import * as types from '../mutation-types';
import FeedbackAPI from '../../api/feedbacks';
import ClarificationPostsAPI from '../../api/clarificationPosts';
import FeedbackUsersAPI from '../../api/feedbackUsers';
import ProposalUsersAPI from '../../api/proposalUsers';
import ProposalsAPI from '../../api/proposals';
import ProConsAPI from '../../api/proCons';
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
  selectedFeedbackId: 0,
  statusTabs: [
    {
      key: 'preview',
      name: 'Preview',
      options: ['preview'],
      main: true,
      filter: 'all',
    },
    {
      key: 'review',
      name: 'Review',
      options: ['review', 'upcoming'],
      main: true,
      filter: 'review',
    },
    {
      key: 'archive',
      name: 'Archive',
      options: ['all', 'reject', 'accept'],
      main: true,
      filter: 'accept',
    },
  ],
  selectedStatusTabIndex: 0,
  bulkSelectIndex: {
    previous: 0,
    current: 0,
  },
  bulkEditCheckStatus: [],
  socom: new Set([]),
};

export const getters = {
  getAllFeedback($state, $getters) {
    const feedbackStatus = $getters.getFeedbackStatus;
    return $state.records.filter(record => {
      if (feedbackStatus.filter === 'all') {
        return feedbackStatus.options.includes(record.status);
      }
      return record.status === feedbackStatus.filter;
    });
  },
  getFeedbackItem: $state => feedbackId => {
    let feedbackItem = {};
    const feedbacks = $state.records;
    for (let index = 0; index < feedbacks.length; index += 1) {
      let feedback = feedbacks[index];
      if (feedback.id === Number(feedbackId)) {
        feedbackItem = feedback;
        break;
      }
    }
    return feedbackItem;
  },
  getPosts: ($state, $getters) => (feedbackId, proposalId) => {
    const feedback = $getters.getFeedbackItem(feedbackId);
    return feedback.posts.filter(post => {
      return post.proposal === proposalId;
    });
  },
  getUIFlags($state) {
    return $state.uiFlags;
  },
  getSelectedFeedbackId($state) {
    return $state.selectedFeedbackId;
  },
  getStatusTabs($state) {
    return $state.statusTabs;
  },
  getFeedbackStatus($state, $getters) {
    return $getters.getStatusTabs[$getters.getSelectedStatusTabIndex];
  },
  getSelectedStatusTabIndex($state) {
    return $state.selectedStatusTabIndex;
  },
  getAvailableStatusOptions($state, $getters) {
    return $getters.getStatusTabs.filter((status, i) => {
      return i !== $getters.getSelectedStatusTabIndex;
    });
  },
  getBulkEditActive($state, $getters) {
    return $getters.getBulkEditCheckStatus.some(status => status);
  },
  getBulkSelectIndex($state) {
    return $state.bulkSelectIndex;
  },

  getBulkEditCheckStatus($state) {
    return $state.bulkEditCheckStatus;
  },
  getBulkSelectedIds($state, $getters) {
    let ids = [];
    let AllFeedbacks = $getters.getAllFeedback;
    let status = $getters.getBulkEditCheckStatus;
    for (let index = 0; index < AllFeedbacks.length; index += 1) {
      if (status[index]) {
        ids.push(AllFeedbacks[index].id);
      }
    }
    return ids;
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
  createFeedback: async ({ commit }, feedbackData) => {
    commit(types.default.SET_FEEDBACK_UI_FLAG, { creatingItem: true });
    try {
      const newFeedback = await FeedbackAPI.create(feedbackData[0]);
      if (feedbackData[1].proposal.details !== '') {
        feedbackData[1].feedback_id = newFeedback.data.id;
        await ProposalsAPI.create(feedbackData[1]);
      }
      if (feedbackData[2].proposal.details !== '') {
        feedbackData[2].feedback_id = newFeedback.data.id;
        await ProposalsAPI.create(feedbackData[2]);
      }
      commit(types.default.ADD_FEEDBACK, newFeedback.data);
      commit(types.default.SET_FEEDBACK_UI_FLAG, { creatingItem: false });
      return newFeedback.data;
    } catch (error) {
      commit(types.default.SET_FEEDBACK_UI_FLAG, { creatingItem: false });
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
  createProposal: async ({ commit }, newProposal) => {
    try {
      const response = await ProposalsAPI.create(newProposal);
      commit(types.default.ADD_PROPOSAL, response.data);
    } catch (error) {
      throw new Error(error);
    }
  },
  deleteProposal: async ({ commit }, id) => {
    try {
      const response = await ProposalsAPI.delete(id);
      commit(types.default.DELETE_PROPOSAL, response.data);
    } catch (error) {
      throw new Error(error);
    }
  },
  updateProposal: async ({ commit }, proposal) => {
    try {
      const response = await ProposalsAPI.update(proposal.id, proposal.payload);
      commit(types.default.UPDATE_PROPOSAL, response.data);
    } catch (error) {
      throw new Error(error);
    }
  },
  createProCon: async ({ commit }, newProCon) => {
    try {
      const response = await ProConsAPI.create(newProCon);
      commit(types.default.ADD_PRO_CON, response.data);
    } catch (error) {
      throw new Error(error);
    }
  },
  deleteProCon: async ({ commit }, id) => {
    try {
      const response = await ProConsAPI.delete(id);
      commit(types.default.DELETE_PRO_CON, response.data);
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
  setBulkSelectIndex({ commit }, data) {
    commit(types.default.SET_BULK_SELECT_INDEX, data);
  },
  setBulkEditCheckStatus({ commit }, data) {
    commit(types.default.SET_BULK_EDIT_CHECK_STATUS, data);
  },
  resetBulkEditCheckStatus({ commit }) {
    commit(types.default.RESET_BULK_EDIT_CHECK_STATUS);
  },
  updateMultipleFeedbacks: async ({ commit }, data) => {
    commit(types.default.SET_FEEDBACK_UI_FLAG, { updatingItem: true });
    try {
      const response = await FeedbackAPI.bulkUpdate(data.payload);
      commit(types.default.UPDATE_MULTIPLE_FEEDBACKS, response.data);
      commit(types.default.SET_FEEDBACK_UI_FLAG, { updatingItem: false });
    } catch (error) {
      commit(types.default.SET_FEEDBACK_UI_FLAG, { updatingItem: false });
    }
  },
  deleteMultipleFeedbacks: async ({ commit }, data) => {
    commit(types.default.SET_FEEDBACK_UI_FLAG, { updatingItem: true });
    try {
      const response = await FeedbackAPI.bulkDelete(data.payload);
      commit(types.default.DELETE_MULTIPLE_FEEDBACKS, response.data.ids);
      commit(types.default.SET_FEEDBACK_UI_FLAG, { updatingItem: false });
    } catch (error) {
      commit(types.default.SET_FEEDBACK_UI_FLAG, { updatingItem: false });
    }
  },
  resetSelectedFeedbackId({ commit }) {
    commit(types.default.RESET_SELECTED_FEEDBACK_ID);
  },
  setSelectedFeedbackId({ commit }, data) {
    commit(types.default.CHANGE_SELECTED_FEEDBACK_ID, data);
  },
  setSelectedStatusTabIndex({ commit }, index) {
    commit(types.default.CHANGE_SELECTED_STATUS_TAB_INDEX, index);
  },
  setSelectedStatusTabFilter({ commit }, data) {
    commit(types.default.CHANGE_SELECTED_STATUS_TAB_FILTER, data);
  },
  setFeedbackEvaluation: async ({ commit }, data) => {
    try {
      const updateResponse = await FeedbackUsersAPI.update(
        data.id,
        data.payload
      );
      commit(types.default.UPDATE_FEEDBACK, updateResponse.data);
    } catch (error) {
      throw new Error(error);
    }
  },
  setProposalEvaluation: async ({ commit }, data) => {
    try {
      let createResponse;
      if (!data.proposalUser) {
        createResponse = await ProposalUsersAPI.create(data.payload);
      } else {
        createResponse = await ProposalUsersAPI.update(data.id, data.payload);
      }
      commit(types.default.UPDATE_PROPOSAL_EVALUATION, createResponse.data);
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
  [types.default.UPDATE_MULTIPLE_FEEDBACKS]:
    MutationHelpers.bulkUpdateAttributes,
  [types.default.DELETE_MULTIPLE_FEEDBACKS]: MutationHelpers.bulkDestroy,
  [types.default.DELETE_FEEDBACK]: MutationHelpers.destroy,
  [types.default.UPDATE_PROPOSAL](_state, payload) {
    let newFeedback = {};
    const index = state.records.findIndex(
      record => record.id === payload.feedback_id
    );
    const feedback = _state.records[index];

    Object.assign(newFeedback, feedback);

    const proposals = newFeedback.proposals;
    const proposalIndex = proposals.findIndex(proposal => {
      return proposal.id === payload.id;
    });

    newFeedback.proposals[proposalIndex].primary = payload.primary;

    Vue.set(_state.records, index, newFeedback);
  },
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
  [types.default.ADD_PROPOSAL](_state, payload) {
    let newFeedback = {};
    const index = state.records.findIndex(
      record => record.id === payload.feedback_id
    );
    let feedback = _state.records[index];

    Object.assign(newFeedback, feedback);
    newFeedback.proposals.push(payload);

    Vue.set(_state.records, index, newFeedback);
  },
  [types.default.ADD_PRO_CON](_state, payload) {
    let newFeedback = {};
    const index = state.records.findIndex(
      record => record.id === payload.feedback_id
    );
    let feedback = _state.records[index];

    Object.assign(newFeedback, feedback);
    newFeedback.proposals = newFeedback.proposals.map(proposal => {
      if (proposal.id === payload.proposal_id) {
        proposal.pro_cons.push(payload.pro_con);
        return proposal;
      }
      return proposal;
    });

    Vue.set(_state.records, index, newFeedback);
  },
  [types.default.DELETE_PRO_CON](_state, payload) {
    let newFeedback = {};
    const index = state.records.findIndex(
      record => record.id === payload.feedback_id
    );
    let feedback = _state.records[index];

    Object.assign(newFeedback, feedback);
    newFeedback.proposals = newFeedback.proposals.map(proposal => {
      if (proposal.id === payload.proposal_id) {
        proposal.pro_cons = proposal.pro_cons.filter(pro_con => {
          return pro_con.id !== payload.id;
        });
      }
      return proposal;
    });

    Vue.set(_state.records, index, newFeedback);
  },
  [types.default.DELETE_PROPOSAL](_state, payload) {
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
  [types.default.UPDATE_PROPOSAL_EVALUATION](_state, payload) {
    let newFeedback = {};
    const index = state.records.findIndex(
      record => record.id === payload.feedback_id
    );
    const feedback = _state.records[index];

    Object.assign(newFeedback, feedback);

    const proposals = newFeedback.proposals;
    const proposalIndex = proposals.findIndex(proposal => {
      return proposal.id === payload.proposal_id;
    });

    const newProposal = newFeedback.proposals[proposalIndex];
    if (payload.evaluation === 'support') {
      if (newProposal.evaluation === 'reject') {
        newProposal.score.down -= 1;
      }
      newProposal.score.up += 1;
    } else if (payload.evaluation === 'reject') {
      if (newProposal.evaluation === 'support') {
        newProposal.score.up -= 1;
      }
      newProposal.score.down += 1;
    } else if (payload.evaluation === 'undecided') {
      if (newProposal.evaluation === 'reject') {
        newProposal.score.down -= 1;
      } else if (newProposal.evaluation === 'support') {
        newProposal.score.up -= 1;
      }
    }
    newProposal.evaluation = payload.evaluation;
    newProposal.proposal_user_id = payload.proposal_user_id;
    newProposal.voted = payload.voted;

    Vue.set(_state.records, index, newFeedback);
  },
  [types.default.CHANGE_SELECTED_FEEDBACK_ID](_state, data) {
    _state.selectedFeedbackId = data;
  },
  [types.default.RESET_SELECTED_FEEDBACK_ID](_state) {
    _state.selectedFeedbackId = 0;
  },
  [types.default.CHANGE_SELECTED_STATUS_TAB_INDEX](_state, data) {
    _state.selectedStatusTabIndex = data;
  },
  [types.default.CHANGE_SELECTED_STATUS_TAB_FILTER](_state, data) {
    let tab = _state.statusTabs[data.index];
    tab.filter = data.value;
    Vue.set(_state.statusTabs, data.index, tab);
  },
  [types.default.SET_BULK_SELECT_INDEX](_state, indexes) {
    _state.bulkSelectIndex = indexes;
  },
  [types.default.SET_BULK_EDIT_CHECK_STATUS](_state, checks) {
    checks.forEach(check => {
      Vue.set(_state.bulkEditCheckStatus, check.index, check.payload);
    });
  },
  [types.default.RESET_BULK_EDIT_CHECK_STATUS](_state) {
    _state.bulkEditCheckStatus = [];
  },
};

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations,
};
