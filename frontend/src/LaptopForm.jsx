import { useState } from 'react';
import { useAuth } from './provider/authProvider';
import { Navigate} from "react-router";

function LaptopForm({ onLaptopAdded, api }) {
    const { isAdmin } = useAuth();
    if (!isAdmin) return <Navigate to="/" replace />;
    const [form, setForm] = useState({ brand: '', model: '', price: '', storage: 512, cpu: '', ram: 16, quantity: 10 });

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            const res = await api.post('/laptops', form);
            alert("Laptop Saved!");
            onLaptopAdded(res.data);
            setForm({ brand: '', model: '', price: '', storage: 512, cpu: '', ram: 16, quantity: 10 });
        } catch (err) { alert("Save failed."); }
    };

    return (
        <form onSubmit={handleSubmit} className="form-style">
            <h3>Add New Laptop</h3>
            <input type="text" placeholder="Brand" value={form.brand} onChange={e => setForm({...form, brand: e.target.value})} required />
            <input type="text" placeholder="Model" value={form.model} onChange={e => setForm({...form, model: e.target.value})} required />
            <input type="text" placeholder="CPU" value={form.cpu} onChange={e => setForm({...form, cpu: e.target.value})} required />
            <input type="number" placeholder="Price" value={form.price} onChange={e => setForm({...form, price: e.target.value})} required />
            <button type="submit">Save Laptop</button>
        </form>
    );
}
export default LaptopForm;