// frontend/src/provider/authProvider.jsx
import { createContext, useContext, useMemo, useState } from "react";

const AuthContext = createContext();

const AuthProvider = ({ children }) => {
    const [token, setToken_] = useState(localStorage.getItem("token"));

    // Robust JWT Decoder
    const getRolesFromToken = (t) => {
        if (!t) return [];
        try {
            // JWT format: [header].[payload].[signature]
            const base64Url = t.split('.')[1];
            const base64 = base64Url.replace('-', '+').replace('_', '/');
            const payload = JSON.parse(window.atob(base64));

            // Return roles list (e.g., ["ROLE_ADMIN"])
            return payload.roles || [];
        } catch (e) {
            console.error("Token decoding failed", e);
            return [];
        }
    };

    const roles = useMemo(() => getRolesFromToken(token), [token]);

    const setToken = (newToken) => {
        setToken_(newToken);
        if (newToken) {
            localStorage.setItem("token", newToken);
        } else {
            localStorage.removeItem("token");
        }
    };

    const contextValue = useMemo(
        () => ({
            token,
            roles,
            isAdmin: roles.includes("ROLE_ADMIN"),
            setToken,
        }),
        [token, roles]
    );

    return <AuthContext.Provider value={contextValue}>{children}</AuthContext.Provider>;
};

export const useAuth = () => useContext(AuthContext);
export default AuthProvider;