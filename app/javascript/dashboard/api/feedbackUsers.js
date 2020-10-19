import ApiClient from './ApiClient';

class FeedbackUsers extends ApiClient {
  constructor() {
    super('feedback_users', { accountScoped: true });
  }
}

export default new FeedbackUsers();
