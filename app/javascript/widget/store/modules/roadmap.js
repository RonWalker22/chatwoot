/* eslint-disable no-param-reassign */
import Vue from 'vue';
import { getRoadmapAPI } from 'widget/api/roadmap';

const state = {
  roadmap: {
    now: {},
    next: {},
    later: {},
  },
};

export const getters = {
  getRoadmap: _state => _state.roadmap,
};

export const actions = {
  fetchRoadmap: async ({ commit }, token = {}) => {
    const { data } = await getRoadmapAPI(token);
    commit('addRoadmap', data);
  },
};

export const mutations = {
  addRoadmap($state, payload) {
    payload.now.forEach(pair => {
      Vue.set($state.roadmap.now, pair.group.id, {
        id: pair.group.id,
        title: pair.group.title,
        body: pair.group.body,
        dueBy: pair.group.due_by,
        items: pair.items,
        status: pair.group.status,
      });
    });
    payload.next.forEach(pair => {
      Vue.set($state.roadmap.next, pair.group.id, {
        id: pair.group.id,
        title: pair.group.title,
        body: pair.group.body,
        dueBy: pair.group.due_by,
        items: pair.items,
        status: pair.group.status,
      });
    });
    payload.later.forEach(pair => {
      Vue.set($state.roadmap.later, pair.group.id, {
        id: pair.group.id,
        title: pair.group.title,
        body: pair.group.body,
        dueBy: pair.group.due_by,
        items: pair.items,
        status: pair.group.status,
      });
    });
  },
};

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations,
};
