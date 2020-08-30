import { API } from 'widget/helpers/axios';
import endPoints from 'widget/api/endPoints';

const getFeedbacksAPI = async websiteToken => {
  const urlData = endPoints.getFeedbacks(websiteToken);
  const result = await API.get(urlData.url, {
    params: urlData.params,
    headers: { 'X-Auth-Token': window.authToken },
  });
  return result;
};

const createFeedbackAPI = async payload => {
  const urlData = endPoints.createFeedback(payload);
  const result = await API.post(urlData.url, urlData.params);
  return result;
};

const createCommentAPI = async payload => {
  const urlData = endPoints.createComment(payload);
  const result = await API.post(urlData.url, urlData.params);
  return result;
};

const createSupporterAPI = async payload => {
  const urlData = endPoints.createSupporter(payload);
  const result = await API.post(urlData.url, urlData.params);
  return result;
};

export {
  getFeedbacksAPI,
  createFeedbackAPI,
  createCommentAPI,
  createSupporterAPI,
};
