import ApiClient from './ApiClient';

class ClarificationPosts extends ApiClient {
  constructor() {
    super('clarification_posts', { accountScoped: true });
  }
}

export default new ClarificationPosts();
