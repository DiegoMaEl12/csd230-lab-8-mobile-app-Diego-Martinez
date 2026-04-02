import { Link } from 'react-router';
import { useAuth } from './provider/authProvider';

function Navbar({ cartCount }) {
    const { isAdmin } = useAuth();

    return (
        <nav className="navbar">
            <Link to="/"> 🏠 Home </Link>
            <span style={{color: '#555'}}> | </span>
            <Link to="/cart"> 🛒 Cart ({cartCount})</Link>
            <span style={{color: '#555'}}>|</span>
            <Link to="/inventory"> 📚 Books </Link>
            <Link to="/magazines"> 📰 Magazines </Link>
            <Link to="/laptops"> 💻 Laptops </Link>
            <Link to="/phones"> 📱 Phones </Link>
            <span style={{color: '#555'}}> | </span>

            {isAdmin && (
                <>
                    <Link to="/add">➕ Add Book</Link>
                    <Link to="/add-magazine">➕ Add Magazine</Link>
                    <Link to="/add-laptop">➕ Add Laptop</Link>
                    <Link to="/add-phone">➕ Add Phone</Link>
                </>
            )}
            <span style={{color: '#555'}}> | </span>

            <Link to="/logout" style={{ color: "#ff4444", marginLeft: "auto" }}>🚪 Logout</Link>
        </nav>
    );
}
export default Navbar;