<template>
  <div>
    <div class="card toolbar-card">
      <div class="row align-center">
        <div class="columns shrink">
          <button class="button large">
            <i class="ion-thumbsup" aria-hidden="true"> </i>
            <span class="action-text">Support</span>
          </button>
        </div>
        <div class="columns shrink">
          <button class="button large">
            <i class="ion-thumbsdown" aria-hidden="true"> </i>
            <span class="action-text">Reject</span>
          </button>
        </div>
        <div class="columns shrink">
          <button class="button large">
            <i class="ion-paper-airplane" aria-hidden="true"> </i>
            <span class="action-text">Move</span>
          </button>
        </div>
        <div class="columns shrink">
          <button class="button large">
            <i class="ion-more" aria-hidden="true"> </i>
            <span class="action-text">More</span>
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped lang="scss">
@import '~dashboard/assets/scss/variables';

.toolbar-card {
  border-radius: 25px;
  background: #0031f2;
  background: white;
  display: inline-block;
  border-color: black;
}

.action-text {
  display: block;
  margin-top: 0.5rem;
}

.button {
  background-color: transparent;
  color: black;
}
</style>
