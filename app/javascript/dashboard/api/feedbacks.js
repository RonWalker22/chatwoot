import ApiClient from './ApiClient';

class Feedbacks extends ApiClient {
  constructor() {
    super('feedbacks', { accountScoped: true });
  }
}

export default new Feedbacks();
