package csd230.bookstore.entities;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.DiscriminatorValue;
import jakarta.persistence.Entity;

import java.util.Objects;

@Entity
@DiscriminatorValue("LAPTOP")
public class LaptopEntity extends ElectronicEntity {
    private String cpu;
    private int ram; // in GB

    public LaptopEntity() {}

    @JsonIgnore
    public LaptopEntity(String brand, String model, double price, int quantity, String cpu, int ram, int storage) {
        super(brand, model, price, quantity, storage);
        this.cpu = cpu;
        this.ram = ram;
    }

    public String getCpu() { return cpu; }
    public void setCpu(String cpu) { this.cpu = cpu; }
    public int getRam() { return ram; }
    public void setRam(int ram) { this.ram = ram; }

    @Override
    public boolean equals(Object o) {
        if (o == null || getClass() != o.getClass()) return false;
        LaptopEntity that = (LaptopEntity) o;
        return ram == that.ram && Objects.equals(cpu, that.cpu);
    }

    @Override
    public int hashCode() {
        return Objects.hash(cpu, ram);
    }

    @Override
    public String toString() {
        return "LaptopEntity{" + super.toString() +
                "cpu='" + cpu + '\'' +
                ", ram=" + ram +
                '}';
    }
}
