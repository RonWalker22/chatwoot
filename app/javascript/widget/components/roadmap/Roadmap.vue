<template>
  <div>
    <div class="columns">
      <div class="column now-column">
        <h2 class="title is-4">
          Now
        </h2>
        <Group
          v-for="group of roadmap.now"
          :key="group.id"
          :items="group.items"
          :title="group.title"
        />
      </div>
      <div class="column next-column">
        <h2 class="title is-4">
          Next
        </h2>
        <Group
          v-for="group of roadmap.next"
          :key="group.id"
          :items="group.items"
          :title="group.title"
        />
      </div>
      <div class="column later-column">
        <h2 class="title is-4">
          Later
        </h2>
        <Group
          v-for="group of roadmap.later"
          :key="group.id"
          :items="group.items"
          :title="group.title"
        />
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex';
import Group from './Group';

export default {
  name: 'Roadmap',
  components: {
    Group,
  },
  computed: {
    ...mapGetters({
      roadmap: 'roadmap/getRoadmap',
    }),
  },
};
</script>

<style lang="scss" scoped>
@import '~widget/assets/feedback/main.scss';

.now-column,
.next-column,
.later-column {
  // margin-top: 1em;
  h2 {
    text-align: center;
  }
}

ul {
  list-style: inside;
}

.columns {
  margin: 0;
}
</style>
