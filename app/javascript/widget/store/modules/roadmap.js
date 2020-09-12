/* eslint-disable no-param-reassign */
import Vue from 'vue';
import { getRoadmapAPI } from 'widget/api/roadmap';

const state = {
  roadmap: {
    undone: {
      now: {},
      next: {},
      later: {},
    },
    done: {},
  },
};

export const getters = {
  getRoadmap: _state => _state.roadmap.undone,
  getChangelog: _state => _state.roadmap.done,
};

export const actions = {
  fetchRoadmap: async ({ commit }, token = {}) => {
    const { data } = await getRoadmapAPI(token);
    commit('addRoadmap', data.undone);
    commit('addChangelog', data.done);
  },
};

export const mutations = {
  addRoadmap($state, payload) {
    payload.now.forEach(pair => {
      Vue.set($state.roadmap.undone.now, pair.group.id, {
        id: pair.group.id,
        title: pair.group.title,
        body: pair.group.body,
        dueBy: pair.group.due_by,
        items: pair.items,
        status: pair.group.status,
      });
    });
    payload.next.forEach(pair => {
      Vue.set($state.roadmap.undone.next, pair.group.id, {
        id: pair.group.id,
        title: pair.group.title,
        body: pair.group.body,
        dueBy: pair.group.due_by,
        items: pair.items,
        status: pair.group.status,
      });
    });
    payload.later.forEach(pair => {
      Vue.set($state.roadmap.undone.later, pair.group.id, {
        id: pair.group.id,
        title: pair.group.title,
        body: pair.group.body,
        dueBy: pair.group.due_by,
        items: pair.items,
        status: pair.group.status,
      });
    });
  },
  addChangelog($state, payload) {
    payload.forEach(pair => {
      Vue.set($state.roadmap.done, pair.group.id, {
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
