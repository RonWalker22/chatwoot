<template>
  <div>
    <div class="row">
      <div class="columns">
        <Proposal
          :index="0"
          :proposal-type="'Problem'"
          :proposal="feedback.problems[0]"
          @click="focusOnProblem(problem.id, problem.solutions)"
        />
        <Proposal
          v-for="(solution, index) in feedback.solutions"
          :key="solution.id"
          :index="index"
          :proposal-type="'Solution'"
          :proposal="solution"
        />
      </div>
    </div>
  </div>
</template>

<script>
import Proposal from './Proposal.vue';

export default {
  components: {
    Proposal,
  },
  props: {
    feedback: {
      type: Object,
      required: true,
    },
  },
};
</script>

<style lang="scss" scoped>
/* #new-problem-btn {
  background:indianred;
  color:white;
}

#new-solution-btn {
  background:steelblue;
  color:white;
}

.focus {
  background:#fbfbfb;
  box-shadow: 0px 0px 5px black;
}

@media screen and (max-width: 770px) {
  .is-pulled-left {
    float: none !important;
  }
  .reverse-col-order {
    display: flex;
    flex-direction: column-reverse;
  }
}

.clear {
  clear: both;
}

.menu-list {
  a {
    cursor: pointer;
  }
} */
</style>
