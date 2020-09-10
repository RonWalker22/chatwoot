import { API } from 'widget/helpers/axios';
import endPoints from 'widget/api/endPoints';

const getRoadmapAPI = async websiteToken => {
  const urlData = endPoints.getRoadmap(websiteToken);
  const result = await API.get(urlData.url, {
    params: urlData.params,
    headers: { 'X-Auth-Token': window.authToken },
  });
  return result;
};

export { getRoadmapAPI };
