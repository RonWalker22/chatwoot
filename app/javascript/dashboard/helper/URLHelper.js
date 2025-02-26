import queryString from 'query-string';

export const frontendURL = (path, params) => {
  const stringifiedParams = params ? `?${queryString.stringify(params)}` : '';
  return `/app/${path}${stringifiedParams}`;
};

export const conversationUrl = ({ accountId, activeInbox, id, label }) => {
  if (activeInbox) {
    return `accounts/${accountId}/inbox/${activeInbox}/conversations/${id}`;
  }
  if (label) {
    return `accounts/${accountId}/label/${label}/conversations/${id}`;
  }
  return `accounts/${accountId}/conversations/${id}`;
};

export const feedbackUrl = ({ accountId, id, label }) => {
  if (label) {
    return `accounts/${accountId}/label/${label}/feedbacks/${id}`;
  }
  if (id) {
    return `accounts/${accountId}/feedbacks/${id}`;
  }
  return `accounts/${accountId}/feedbacks`;
};

export const accountIdFromPathname = pathname => {
  const isInsideAccountScopedURLs = pathname.includes('/app/accounts');
  const urlParam = pathname.split('/')[3];
  // eslint-disable-next-line no-restricted-globals
  const isScoped = isInsideAccountScopedURLs && !isNaN(urlParam);
  const accountId = isScoped ? Number(urlParam) : '';
  return accountId;
};
