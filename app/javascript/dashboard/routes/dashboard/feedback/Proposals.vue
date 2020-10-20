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
