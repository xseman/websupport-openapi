import swagger from "https://esm.sh/swagger-ui-dist@5.26";
import crypto from "https://esm.sh/crypto-js@4.2";

const specs = "https://raw.githubusercontent.com/xseman/websupport.openapi/refs/heads/master";
// const specs = "http://localhost:8000";

swagger.SwaggerUIBundle({
	dom_id: "#swagger-ui",
	urls: [
		{ name: "Websupport API v1", url: `${specs}/openapi.yaml` },
		{ name: "Websupport API v2", url: `${specs}/openapi.v2.yaml` },
	],
	"urls.primaryName": "Websupport API v1",
	// The spec selector (urls) is rendered by the topbar of the standalone layout.
	presets: [swagger.SwaggerUIBundle.presets.apis, swagger.SwaggerUIStandalonePreset],
	layout: "StandaloneLayout",
	syntaxHighlight: { theme: "idea" },
	deepLinking: true,
	persistAuthorization: true,
	requestInterceptor: websupportAuth,
});

/**
 * Signs the request the way the official docs describe (v1: docs/v1.intro,
 * v2: v2/docs/intro): HMAC-SHA1 of `{method} {path} {unix timestamp}`, the
 * timestamp sent in the `Date` (v1) or `X-Date` (v2) header.
 *
 * @param {swagger.SwaggerRequest} req 
 */
function websupportAuth(req) {
	const auth = JSON.parse(window.localStorage.getItem("authorized"));
	if (auth) {
		const {
			username: apiKey, 
			password: secret
		} = auth.basicAuth.value;
		
		const now = new Date();
		const timestamp = Math.floor(now.getTime() / 1_000);
		const path = new URL(req.url).pathname;
		const isV2 = path.startsWith("/v2/") || path.startsWith("/nic/");

		const signature = crypto
			.HmacSHA1(`${req.method} ${path} ${timestamp}`, secret)
			.toString(crypto.enc.Hex);

		console.log(req.method, path, timestamp);

		req.headers = {
			...req.headers,
			[isV2 ? "X-Date" : "Date"]: now.toISOString(),
			Authorization: "Basic " + window.btoa(apiKey + ":" + signature),
		};
	}

	return req;
}

