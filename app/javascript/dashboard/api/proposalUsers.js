import ApiClient from './ApiClient';

class ProposalUsers extends ApiClient {
  constructor() {
    super('proposal_users', { accountScoped: true });
  }
}

export default new ProposalUsers();
