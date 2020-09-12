<template>
  <div>
    <div class="columns">
      <div class="column">
        <h1 class="title has-text-centered is-4">
          What's New
        </h1>
        <div class="box">
          <Group
            v-for="group of changelog"
            :key="group.id"
            :items="group.items"
            :title="group.title"
          />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex';
import Group from './Group';

export default {
  name: 'Changelog',
  components: {
    Group,
  },
  computed: {
    ...mapGetters({
      changelog: 'roadmap/getChangelog',
    }),
  },
};
</script>

<style lang="scss" scoped>
@import '~widget/assets/feedback/main.scss';

ul {
  list-style: inside;
}

.columns {
  margin: 0;
}
</style>
