import ApiClient from './ApiClient';

class Feedbacks extends ApiClient {
  constructor() {
    super('feedbacks', { accountScoped: true });
  }

  bulkUpdate(data) {
    // eslint-disable-next-line no-undef
    return axios.patch(`${this.url}/bulk_update`, data);
  }

  bulkDelete(data) {
    // eslint-disable-next-line no-undef
    return axios.delete(`${this.url}/bulk_destroy`, { data: data });
  }
}

export default new Feedbacks();
