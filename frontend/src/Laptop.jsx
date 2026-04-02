import { useState } from 'react';
import { useAuth } from './provider/authProvider';

function Laptop({ id, brand, model, price, storage, cpu, ram, quantity, onDelete, onUpdate, onAddToCart }) {
    const { isAdmin } = useAuth();
    const [isEditing, setIsEditing] = useState(false);
    const [tempData, setTempData] = useState({ brand, model, price, storage, cpu, ram, quantity });

    const handleSave = () => {
        onUpdate(id, { ...tempData, price: parseFloat(tempData.price) });
        setIsEditing(false);
    };

    if (isEditing) {
        return (
            <div className="book-row editing">
                <input type="text" value={tempData.brand} onChange={e => setTempData({...tempData, brand: e.target.value})} placeholder="Brand" />
                <input type="text" value={tempData.model} onChange={e => setTempData({...tempData, model: e.target.value})} placeholder="Model" />
                <input type="number" value={tempData.price} onChange={e => setTempData({...tempData, price: e.target.value})} placeholder="Price" />
                <button onClick={handleSave} className="btn-save">Save</button>
                <button onClick={() => setIsEditing(false)}>Cancel</button>
            </div>
        );
    }

    return (
        <div className="book-row">
            <div className="book-info">
                <h3>{brand} {model}</h3>
                <p><strong>CPU:</strong> {cpu} | <strong>RAM:</strong> {ram}GB | <strong>Storage:</strong> {storage}GB | <strong>Price:</strong> ${Number(price).toFixed(2)}</p>
            </div>
            <div className="book-actions">
                <button onClick={() => onAddToCart(id)} style={{ backgroundColor: '#28a745', color: 'white' }}>🛒 Add to Cart</button>
                {isAdmin && (
                    <>
                        <button onClick={() => setIsEditing(true)} style={{ backgroundColor: '#ffc107' }}>Edit</button>
                        <button onClick={() => onDelete(id)} style={{ backgroundColor: '#ff4444', color: 'white' }}>Delete</button>
                    </>
                )}
            </div>
        </div>
    );
}
export default Laptop;