import http from 'k6/http';

export const options = {
  scenarios: {
    constant_rate: {
      executor: 'constant-arrival-rate',
      rate: 1,
      timeUnit: '1s',
      duration: '1m',
      preAllocatedVUs: 1,
      maxVUs: 1,
    },
  },
};

export default function () {
  let res = http.get('http://k6-start-nginx:80/one');
  console.log(`${res.status}' : '${res.body}`);
}