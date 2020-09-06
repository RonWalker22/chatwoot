<template>
  <div>
    <div class="columns">
      <div class="column color-column">
        <h2 class="title">
          Now
        </h2>
        <ul>
          <li v-for="campaign of roadmap.Now" :key="campaign.id">
            <nuxt-link :to="'/campaigns/' + campaign.id">
              {{ campaign.title }}
            </nuxt-link>
          </li>
        </ul>
      </div>
      <div class="column">
        <h2 class="title">
          Next
        </h2>
        <ul>
          <li v-for="campaign of roadmap.Next" :key="campaign.id">
            <nuxt-link :to="'/campaigns/' + campaign.id">
              {{ campaign.title }}
            </nuxt-link>
          </li>
        </ul>
      </div>
      <div class="column color-column">
        <h2 class="title">
          Later
        </h2>
        <ul>
          <li v-for="campaign of roadmap.Later" :key="campaign.id">
            <nuxt-link :to="'/campaigns/' + campaign.id">
              {{ campaign.title }}
            </nuxt-link>
          </li>
        </ul>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    roadmap: {
      type: Object,
      required: false,
      default: Object,
    },
  },
};
</script>

<style lang="scss" scoped>
@import '~widget/assets/feedback/main.scss';

.color-column {
  color: white;
  background: $ik4-color;
  a {
    color: white;
    :hover {
      color: white;
    }
  }
  h2 {
    color: white;
  }
}

ul {
  list-style: inside;
}

.columns {
  margin: 0;
}
</style>
