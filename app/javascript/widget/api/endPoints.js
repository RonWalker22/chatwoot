import { buildSearchParamsWithLocale } from '../helpers/urlParamsHelper';

const sendMessage = content => {
  const refererURL = window.refererURL || '';
  const search = buildSearchParamsWithLocale(window.location.search);
  return {
    url: `/api/v1/widget/messages${search}`,
    params: {
      message: {
        content,
        timestamp: new Date().toString(),
        referer_url: refererURL,
      },
    },
  };
};

const sendAttachment = ({ attachment }) => {
  const { refererURL = '' } = window;
  const timestamp = new Date().toString();
  const { file } = attachment;

  const formData = new FormData();
  formData.append('message[attachments][]', file, file.name);
  formData.append('message[referer_url]', refererURL);
  formData.append('message[timestamp]', timestamp);
  return {
    url: `/api/v1/widget/messages${window.location.search}`,
    params: formData,
  };
};

const getConversation = ({ before }) => ({
  url: `/api/v1/widget/messages${window.location.search}`,
  params: { before },
});

const updateMessage = id => ({
  url: `/api/v1/widget/messages/${id}${window.location.search}`,
});

const getAvailableAgents = token => ({
  url: '/api/v1/widget/inbox_members',
  params: {
    website_token: token,
  },
});

const getFeedbacks = token => ({
  url: '/api/v1/feedbacks',
  params: {
    website_token: token,
  },
});

const createFeedback = payload => ({
  url: '/api/v1/feedbacks',
  params: {
    feedback: {
      title: payload.title,
    },
    support_level: payload.supportLevel,
    problem: payload.problem,
    solution: payload.solution,
    email: payload.email,
    details: payload.details,
    website_token: payload.websiteToken,
    supporter: true,
  },
});

const createComment = payload => ({
  url: '/api/v1/clarification_posts',
  params: {
    body: payload.details,
    website_token: payload.websiteToken,
    feedback_id: payload.feedbackId,
    email: payload.email,
    supporter: false,
  },
});

const createSupporter = payload => ({
  url: '/api/v1/feedback_contacts',
  params: {
    support_level: payload.supportLevel,
    website_token: payload.websiteToken,
    feedback_id: payload.feedbackId,
    email: payload.email,
    supporter: true,
  },
});

export default {
  sendMessage,
  sendAttachment,
  getConversation,
  updateMessage,
  getAvailableAgents,
  getFeedbacks,
  createFeedback,
  createComment,
  createSupporter,
};
