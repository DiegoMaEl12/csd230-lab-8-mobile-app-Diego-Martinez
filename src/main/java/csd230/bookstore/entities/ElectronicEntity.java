package csd230.bookstore.entities;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.Entity;

@Entity
public abstract class ElectronicEntity extends ProductEntity {
    private String brand;
    private String model;
    private double price;
    private int quantity;
    private int storage;

    public ElectronicEntity() {}

    @JsonIgnore
    public ElectronicEntity(String brand, String model, double price, int quantity, int storage) {
        this.brand = brand;
        this.model = model;
        this.price = price;
        this.quantity = quantity;
        this.storage = storage;
    }
    public String getBrand() { return brand; }
    public void setBrand(String b) { this.brand = b; }
    public String getModel() { return model; }
    public void setModel(String m) { this.model = m; }
    public void setPrice(double p) { this.price = p; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int q) { this.quantity = q; }
    public int getStorage() { return storage; }
    public void setStorage(int s) { this.storage = s; }
    @Override
    public String toString() {
        return "Electronic{brand='" + brand + "', model='" + model + "', " + super.toString() + "}";
    }
    @Override
    public void sellItem() {
        if (quantity > 0) {
            quantity--;
            System.out.println("Sold " + brand + " " + model + ". Remaining quantity: " + quantity);
        } else {
            System.out.println("Cannot sell " + brand + " " + model + ". Out of stock.");
        }
    }
    @Override
    public Double getPrice() {
        return this.price;
    }
}
