import ApiClient from './ApiClient';

class Proposals extends ApiClient {
  constructor() {
    super('proposals', { accountScoped: true });
  }
}

export default new Proposals();
