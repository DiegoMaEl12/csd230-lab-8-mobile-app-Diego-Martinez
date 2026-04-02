import { useState } from "react";
import { useNavigate, useLocation } from "react-router";
import { useAuth } from "../provider/authProvider";
import api from "../api/axiosConfig";

const Login = () => {
    const { setToken } = useAuth();
    const navigate = useNavigate();
    const location = useLocation();

    const queryParams = new URLSearchParams(location.search);
    const isExpired = queryParams.get("expired");

    const [email, setEmail] = useState("");
    const [password, setPassword] = useState("");
    const [error, setError] = useState("");

    const handleLogin = async (e) => {
        e.preventDefault();
        setError("");

        try {
            const res = await api.post("/auth/login", { email, password });
            setToken(res.data.token);
            navigate("/", { replace: true });
        } catch (err) {
            console.error("Login Error:", err.response?.data || err.message);
            setError("Invalid username or password. Please try again.");
        }
    };

    return (
        <div style={{ textAlign: "center", marginTop: "50px" }}>
            <h1>Bookstore Admin</h1>
            <h2>Sign In</h2>

            {/* NEW for 2.12.1: Session Expired Warning */}
            {isExpired && (
                <div style={{
                    backgroundColor: '#fff3cd',
                    color: '#856404',
                    padding: '12px',
                    borderRadius: '5px',
                    display: 'inline-block',
                    marginBottom: '20px',
                    border: '1px solid #ffeeba',
                    fontWeight: 'bold'
                }}>
                    ⚠️ Your session has expired. Please log in again to continue.
                </div>
            )}

            {/* Error Message Display */}
            {error && (
                <p style={{
                    color: "white",
                    backgroundColor: "#ff4444",
                    padding: "10px",
                    borderRadius: "5px",
                    display: "inline-block"
                }}>
                    {error}
                </p>
            )}

            <br />

            <form onSubmit={handleLogin} style={{ display: "inline-block", textAlign: "left", minWidth: "300px" }}>
                <div style={{ marginBottom: "15px" }}>
                    <label>Username:</label><br/>
                    <input
                        type="text"
                        value={email}
                        onChange={(e) => setEmail(e.target.value)}
                        required
                        style={{ width: "100%", padding: "8px", boxSizing: "border-box" }}
                        placeholder="e.admin"
                    />
                    <small style={{display:"block", color:"#888", marginTop: "4px"}}>Hint: try 'admin' or 'user'</small>
                </div>

                <div style={{ marginBottom: "20px" }}>
                    <label>Password:</label><br/>
                    <input
                        type="password"
                        value={password}
                        onChange={(e) => setPassword(e.target.value)}
                        required
                        style={{ width: "100%", padding: "8px", boxSizing: "border-box" }}
                    />
                </div>

                <button
                    type="submit"
                    style={{
                        width: "100%",
                        padding: "10px",
                        backgroundColor: "#007bff",
                        color: "white",
                        border: "none",
                        borderRadius: "5px",
                        cursor: "pointer",
                        fontSize: "16px"
                    }}
                >
                    Login
                </button>
            </form>
        </div>
    );
};

export default Login;