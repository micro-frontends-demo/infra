'use strict';

exports.handler = (event, context, callback) => {
    const request = event.Records[0].cf.request;

    console.log(`Request is for ${request.uri}`);

    request.uri = request.uri.replace(
      new RegExp('/static/js/main.*.js'),
      '/static/js/bundle.js'
    );

    console.log(`Request uri set to "${request.uri}"`);

    callback(null, request);
};
