import ApiClient from './ApiClient';

class ProCons extends ApiClient {
  constructor() {
    super('pro_cons', { accountScoped: true });
  }
}

export default new ProCons();
