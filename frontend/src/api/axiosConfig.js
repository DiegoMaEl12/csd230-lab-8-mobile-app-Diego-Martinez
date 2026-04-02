import axios from 'axios';

const api = axios.create({
    baseURL: '/api/rest'
});

// REQUEST Interceptor: Attach JWT to every request
api.interceptors.request.use(
    (config) => {
        const token = localStorage.getItem('token');
        if (token) {
            config.headers['Authorization'] = `Bearer ${token}`;
        }
        return config;
    },
    (error) => Promise.reject(error)
);

// RESPONSE Interceptor: Catch security errors
api.interceptors.response.use(
    (response) => response,
    (error) => {
        // If the server returns 401 (Expired/Invalid) or 403 (No Permission)
        if (error.response && (error.response.status === 401 || error.response.status === 403)) {
            console.warn("Security error: Redirecting to login...");

            // 1. Wipe the stale token
            localStorage.removeItem('token');

            // 2. Hard redirect with the 'expired' query parameter
            window.location.href = '/login?expired=true';
        }
        return Promise.reject(error);
    }
);

export default api;