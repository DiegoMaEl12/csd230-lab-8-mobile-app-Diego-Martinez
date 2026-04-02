package csd230.bookstore.entities;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.DiscriminatorValue;
import jakarta.persistence.Entity;

import java.util.Objects;

@Entity
@DiscriminatorValue("PHONE")
public class PhoneEntity extends ElectronicEntity {
    private String os;
    public PhoneEntity() {}

    @JsonIgnore
    public PhoneEntity(String brand, String model, double price, int quantity, String os, int storage) {
        super(brand, model, price, quantity, storage);
        this.os = os;
    }
    public String getOs() { return os; }

    public void setOs(String os) { this.os = os; }
    @Override
    public boolean equals(Object o) {
        if (o == null || getClass() != o.getClass()) return false;
        PhoneEntity that = (PhoneEntity) o;
        return Objects.equals(os, that.os);
    }
    @Override
    public int hashCode() {
        return Objects.hashCode(os);
    }
    @Override
    public String toString() {
        return "Phone{ " + super.toString() +
                "Operating System='" + os + '\'' +
                '}';
    }
}
